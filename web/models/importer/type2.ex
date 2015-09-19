defmodule Expensive.Importer.Type2 do
  
  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Transaction

  @moduledoc """
  Imports the oldest format transaction file.
  """
  
  @header ["Date", "No.", "Description", "Debit", "Credit", "Notes"]

  def header do
    @header
  end

  def parse([date, num, desc, debit]) do
    parse([date, num, desc, debit, "", ""])
  end

  def parse([date, _num, _desc, _debit, _credit]) do
    parse([date, _num, _desc, _debit, _credit, ""])
  end

  def parse(@header), do: nil
  def parse([date, _num, desc, debit, credit, notes]) do
    [year, month, day] = date_to_ymd(date)
    amount = txn_amount(debit, credit)
    check_check = Regex.run(~r{^check \# (\d+)}i, desc, capture: :all_but_first)
    if check_check do
      check_num = check_check
      |> List.first
      |> String.to_integer
    end
    category_id = assign_category(notes)
    
    if ! duplicate_transaction?(year, month, day, desc, amount, check_num) do
      Repo.insert!(%Transaction{year: year, month: month, day: day,
                                description: desc, amount: amount,
                                category_id: category_id,
                                check_num: check_num})
    end
  end
end
