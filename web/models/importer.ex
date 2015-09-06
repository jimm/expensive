defmodule Expensive.Importer do

  @category_names [             # Must be list (ordered)
    ["doctors", "Doctors"],
    ["education", "Education"],
    ["taxes", "Taxes"],
    ["Medical", "Doctors"],
    [~r{taxes medical}, "Doctors"],
    ["charity", "Charity"],
    [~r{taxes charity}, "Charity"],
    ["business", "Business"],
    [~r{taxes business}, "Business"],
    [~r{taxes house}, "House"],
    [~r{tax preparation}, "House"],
    [~r{taxes}, "Taxes"]
  ]

  def transactions(file) do
    stream = CSVLixir.read(file)
    first_row = Stream.take(stream, 1)
    transform_function = case first_row do
      ["Date", "No.", "Description", "Debit", "Credit"] -> &type1_txn/1
      ["Date", "No.", "Description", "Debit", "Credit", "Notes"] -> &type2_txn/1
      ["Date", "CheckNum", "Description", "Withdrawal", "Deposit", "Additional Info", "Notes"] -> &type3_txn/1
                         end
    stream
    |> Enum.map(&(Task.async(fn -> transform_function.(&1) end)))
    |> Enum.map(&(Task.await(&1)))
    :ok
  end

  def checks(file) do
    CSVLixir.read(file)
    |> Enum.to_list
    :ok
  end

  defp date_to_ymd(date_str) do
    mdy = Regex.run(~r{(\d\d?)/(\d\d?)/(\d\d\d\d)}i,
                    date_str, capture: :all_but_first)
    [String.to_integer(mdy[2]),
     String.to_integer(mdy[0]),
     String.to_integer(mdy[1])]
  end

  defp type1_txn([date, num, desc, debit, credit] = row) do
    [year, month, day] = date_to_ymd(date)
    amount = if debit == "" do
      abs(String.to_integer(credit))
    else
      abs(String.to_integer(debit))
    end

    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer

      # TODO handle bad insert
      case Repo.insert(%Expensive.Check{id: check_num, description: desc}) do
        {:ok, _model} -> :ok
        {:error, _changeset} -> :error
      end
    end

    # TODO handle bad insert
    case Repo.insert(%Expensive.Transaction{year: year, month: month, day: day,
                                            description: row[2], amount: amount}) do
      {:ok, _model} -> :ok
      {:error, _changeset} -> :error
    end
  end

  defp type2_txn([date, num, desc, debit, credit, notes] = row) do
    [year, month, day] = date_to_ymd(date)
    amount = if debit == "" do
      abs(String.to_integer(credit))
    else
      abs(String.to_integer(debit))
    end

    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer

      # TODO handle bad insert
      case Repo.insert(%Expensive.Check{id: check_num, description: desc}) do
        {:ok, _model} -> :ok
        {:error, _changeset} -> :error
      end
    end

    # TODO category from notes

    # TODO handle bad insert
    case Repo.insert(%Expensive.Transaction{year: year, month: month, day: day,
                                            description: row[2], amount: amount}) do
      {:ok, _model} -> :ok
      {:error, _changeset} -> :error
    end
  end

  defp type3_txn([date, desc, debit, credit, addl_info, notes] = row) do
    [year, month, day] = date_to_ymd(date)
    amount = if debit == "" do
      abs(String.to_integer(credit))
    else
      abs(String.to_integer(debit))
    end

    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer

      # TODO handle bad insert
      case Repo.insert(%Expensive.Check{id: check_num, description: desc}) do
        {:ok, _model} -> :ok
        {:error, _changeset} -> :error
      end
    end

    # TODO category from notes
    # TODO type

    # TODO handle bad insert
    case Repo.insert(%Expensive.Transaction{year: year, month: month, day: day,
                                            description: row[2], amount: amount}) do
      {:ok, _model} -> :ok
      {:error, _changeset} -> :error
    end
  end

  defp assign_category(category_text) do
    if category_text == "", do: return nil
      
    # TODO
    # @category_names
    # |> Enum.map(&())
    # |> Enum.filter(&(&1 != nil))
    # |> List.first  
    nil
  end
end
