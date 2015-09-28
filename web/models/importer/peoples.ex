defmodule Expensive.Importer.Peoples do

  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Transaction

  @moduledoc """
  Imports the raw People's United CSV download file format.
  """

  @header ["<Date>", "<CheckNum>", "<Description>", "<Withdrawal Amount>", "<Deposit Amount>", "<Additional Info>"]

  def first_row do
    []
  end

  def header do
    @header
  end

  def parse([]), do: nil
  def parse(@header), do: nil
  def parse([date, "", type, debit, credit, desc]) do
    parse([date, nil, type, debit, credit, desc])
  end
  def parse([date, check_num, type, debit, credit, desc]) do
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
  def parse(something_else) do
    IO.puts "something_else = #{inspect something_else}" # DEBUG
  end
end
