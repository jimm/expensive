defmodule Expensive.Importer.Type3 do
  
  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Transaction

  @moduledoc """
  Imports the oldest format transaction file.
  """
  
  @header ["Date", "CheckNum", "Type", "Withdrawal", "Deposit", "Additional Info", "Notes"]

  def header do
    @header
  end

  def parse(["Date", _check_num, _type, _debit, _credit, _desc]), do: nil
  def parse([date, check_num, type, debit, credit, desc]) do
    parse([date, check_num, type, debit, credit, desc, ""])
  end

  def parse(@header), do: nil
  def parse([date, check_num, type, debit, credit, desc, notes]) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    check_num = if check_num && check_num != "" && Regex.match?(~r{CHECK|OTC CASHED CHECK}, type) do
      String.to_integer(check_num)
    else
      nil
    end
    category_id = assign_category(notes)
    if ! duplicate_transaction?(year, month, day, desc, amount, check_num) do
      Repo.insert!(%Transaction{year: year, month: month, day: day,
                                description: desc, amount: amount,
                                type: type, category_id: category_id,
                                check_num: check_num})
    end
    if check_num do
      Expensive.Importer.save_check([check_num, desc, debit, nil])
    end
  end
end
