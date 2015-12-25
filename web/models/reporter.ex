defmodule Expensive.Reporter do

  # import Expensive.Importer.Common
  import Ecto.Query
  alias Expensive.Repo
  # alias Expensive.Check
  alias Expensive.Transaction
  alias Expensive.Category

  @moduledoc """
  Reports return maps that are best described by example:

      %{2015 => %{1 => %{"Doctors" => [rec1, rec2...], "Taxes" => [...]},
                  2 => %{"Doctors" => [rec1, rec2...], "Taxes" => [...]},
                  ...
                  12 => %{"Doctors" => [rec1, rec2...], "Taxes" => [...]}},
       2014 => %{...},
       ...}
  """

  # def budget(categories, transactions) do
  #   for year <- (2002..current_year),
  #       month <- (1..12),
  #       cat <- categories,
  #       txn <- transactions_in(transactions, year, month, cat.id) do
  #         {year, month, cat.description, txn.description}
  #         # TODO non-categorized transactions
  #   end
  # end

  # def taxes do
  #   # TODO
  #   {[], []}
  # end

  defp current_year do
    ts = :os.timestamp
    {{year, _m, _d}, {_h, _min, _s}} = :calendar.now_to_universal_time(ts)
    year
  end

  defp transactions_in(transactions, year, month, category_id) do
    transactions
    |> Enum.filter(fn(txn) ->
      txn.year == year && txn.month == month && txn.category_id == category_id
    end)
  end
end
