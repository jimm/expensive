defmodule Expensive.Importer.Common do
  
  import Ecto.Query
  alias Expensive.Repo
  alias Expensive.Category
  alias Expensive.CategoryRegex
  alias Expensive.Transaction

  @moduledoc """
  Functions common to importers.
  """

  def date_to_ymd(date_str) do
    [m, d, y] = Regex.run(~r{(\d\d?)/(\d\d?)/(\d\d\d\d)}i,
                          date_str, capture: :all_but_first)
    [String.to_integer(y), String.to_integer(m), String.to_integer(d)]
  end

  def assign_category(nil), do: nil
  def assign_category(""), do: nil
  def assign_category(category_text) do
    cr = Repo.all(from cr in CategoryRegex, order_by: cr.id)
         |> CategoryRegex.find_matching(category_text)
    if cr do
      cr.category_id
    else
      category = Repo.insert!(%Category{description: category_text})
      category.id
    end
  end

  def txn_amount(debit, credit) do
    if debit == nil || debit == "" do
      money_str_to_int(credit)
    else
      - money_str_to_int(debit)
    end
  end

  @doc """
  Turns money string into positive integer number of cents.
  """
  def money_str_to_int(s) do
    {f, _} = Float.parse(s)
    f * 100
    |> abs
    |> trunc
  end

  def duplicate_transaction?(year, month, day, desc, amount, nil) do
    Repo.get_by(Transaction, year: year, month: month, day: day,
                description: desc, amount: amount) != nil
  end
  def duplicate_transaction?(year, month, day, _desc, amount, check_num) do
    Repo.get_by(Transaction, year: year, month: month, day: day,
                amount: amount, check_num: check_num) != nil
  end
end
