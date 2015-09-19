defmodule Expensive.Importer.Type1 do
  
  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Transaction
  
  @moduledoc """
  Imports the oldest format transaction file.
  """
  
  @header ["Date", "No.", "Description", "Debit", "Credit"]

  def header do
    @header
  end

  def parse([date, num, desc, debit]) do
    parse([date, num, desc, debit, "", nil])
  end

  def parse(@header), do: nil
  def parse([date, num, desc, debit, credit]) do
    parse([date, num, desc, debit, credit, nil])
  end

  def parse([date, _num, desc, debit, credit, nil]) do
    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer
    end
    parse(date, desc, debit, credit, check_num)
  end
  def parse([date, _num, desc, debit, credit, check_num]) when is_binary(check_num) do
    parse(date, desc, debit, credit, String.to_integer(check_num))
  end
  def parse([date, _num, desc, debit, credit, check_num]) do
    parse(date, desc, debit, credit, check_num)
  end

  def parse(date, desc, debit, credit, check_num) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    if ! duplicate_transaction?(year, month, day, desc, amount, check_num) do
      Repo.insert!(%Transaction{year: year, month: month, day: day,
                                description: desc, amount: amount,
                                check_num: check_num})
    end
    if check_num do
      Expensive.Importer.save_check([check_num, desc, debit, nil])
    end
  end
end
