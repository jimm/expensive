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

  def budget do
    categories = Repo.all(Category)
    for year <- (2002..current_year),
        month <- (1..12),
        cat <- categories,
        txn <- Repo.all(from t in Transaction,
                        where: t.year == ^year and t.month == ^month and t.category_id == ^cat.id) do
          {year, month, cat.description, txn.description}
          # TODO non-categorized transactions
    end
  end

  def taxes do
    # TODO
    {[], []}
  end

  defp current_year do
    ts = :os.timestamp
    {{year, _m, _d}, {_h, _min, _s}} = :calendar.now_to_universal_time(ts)
    year
  end
end
