defmodule Expensive.Reporter do

  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Check
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
    # TODO
    {[], []}
  end

  def taxes do
    # TODO
    {[], []}
  end
end
