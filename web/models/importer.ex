defmodule Expensive.Importer do

  alias Expensive.Repo
  alias Expensive.Category
  alias Expensive.CategoryRegex
  alias Expensive.Check
  alias Expensive.Transaction

  def transactions(file) do
    transform_function = transform_func_from_headers(file)
    CSVLixir.read(file)
    |> Stream.map(&(transform_function.(&1)))
    # |> Stream.map(&(Task.async(fn -> transform_function.(&1) end)))
    # |> Stream.map(&(Task.await(&1)))
    |> Stream.run
    :ok
  end

  def checks(file) do
    # TODO get category, assign to transaction
    CSVLixir.read(file)
    |> Stream.map(&save_check/1)
    # |> Stream.map(&(Task.async(save_check(&1))))
    # |> Stream.map(&(Task.await(&1)))
    |> Stream.run
    :ok
  end

  defp transform_func_from_headers(file) do
    stream = CSVLixir.read(file)
    first_row = stream
    |> Stream.take(1)
    |> Enum.to_list
    |> List.first
    case first_row do
      ["Date", "No.", "Description", "Debit", "Credit"] -> &type1_txn/1
      ["Date", "No.", "Description", "Debit", "Credit", "Notes"] -> &type2_txn/1
      ["Date", "CheckNum", "Type", "Withdrawal", "Deposit", "Additional Info", "Notes"] -> &type3_txn/1
    end
  end

  defp date_to_ymd(date_str) do
    [m, d, y] = Regex.run(~r{(\d\d?)/(\d\d?)/(\d\d\d\d)}i,
                          date_str, capture: :all_but_first)
    [String.to_integer(y),
     String.to_integer(m),
     String.to_integer(d)]
  end

  defp type1_txn(["Date", _num, _desc, _debit]), do: nil
  defp type1_txn([date, num, desc, debit]) do
    type1_txn([date, num, desc, debit, ""])
  end

  defp type1_txn(["Date", _num, _desc, _debit, _credit]), do: nil
  defp type1_txn([date, _num, desc, debit, credit]) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer
    end
    Repo.insert!(%Transaction{year: year, month: month, day: day,
                              description: desc, amount: amount,
                              check_num: check_num})
  end

  defp type2_txn(["Date", _num, _desc, _debit]), do: nil
  defp type2_txn([date, num, desc, debit]) do
    type2_txn([date, num, desc, debit, "", ""])
  end

  defp type2_txn(["Date", _num, _desc, _debit, _credit]), do: nil
  defp type2_txn([date, _num, _desc, _debit, _credit]) do
    type2_txn([date, _num, _desc, _debit, _credit, ""])
  end

  defp type2_txn(["Date", _num, _desc, _debit, _credit, _notes]), do: nil
  defp type2_txn([date, _num, desc, debit, credit, notes]) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer
    end
    category_id = assign_category(notes)
    Repo.insert!(%Transaction{year: year, month: month, day: day,
                              description: desc, amount: amount,
                              category_id: category_id,
                              check_num: check_num})
  end

  defp type3_txn(["Date", _check_num, _type, _debit, _credit, _desc]), do: nil
  defp type3_txn([date, check_num, type, debit, credit, desc]) do
    type3_txn([date, check_num, type, debit, credit, desc, ""])
  end
  defp type3_txn(["Date", _check_num, _type, _debit, _credit, _desc, _notes]), do: nil
  defp type3_txn([date, check_num, type, debit, credit, desc, notes]) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    check_num = if Regex.match?(~r{CHECK|OTC CASHED CHECK}, type), do: String.to_integer(check_num), else: nil
    category_id = assign_category(notes)
    Repo.insert!(%Transaction{year: year, month: month, day: day,
                              description: desc, amount: amount,
                              type: type, category_id: category_id,
                              check_num: check_num})
  end

  defp assign_category(nil), do: nil
  defp assign_category(""), do: nil
  defp assign_category(category_text) do
    cr = CategoryRegex.find_matching(category_text)
    if cr do
      cr.category_id
    else
      {:ok, category} = Repo.insert!(%Category{description: category_text})
      category.id
    end
  end

  defp txn_amount(debit, credit) do
    if debit == nil || debit == "" do
      money_str_to_int(credit)
    else
      - money_str_to_int(debit)
    end
  end

  # Turns money string into positive integer number of cents.
  defp money_str_to_int(s) do
    {f, _} = Float.parse(s)
    f * 100
    |> abs
    |> trunc
  end

  defp save_check([num, description, amount]), do: save_check([num, description, amount, nil])
  defp save_check([num, description, amount, note]) do
    check_num = String.to_integer(num)
    check = Repo.get_by(Check, id: check_num)
    txn = Repo.get_by(Transaction, check_num: check_num)

    # Data integrity check
    if txn do
      amount_cents = money_str_to_int(amount)
      true = (-amount_cents == txn.amount)
    end

    category_id = assign_category(note)
    if check == nil do
      Repo.insert!(%Check{id: String.to_integer(num),
                          description: description,
                          transaction_id: txn && txn.id,
                          category_id: category_id, notes: note})
    end
  end
end
