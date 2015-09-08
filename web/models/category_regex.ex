defmodule Expensive.CategoryRegex do
  use Expensive.Web, :model
  import Ecto.Query, only: [from: 2]

  schema "category_regexes" do
    field :regex, :string
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(regex)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Finds the record matching `str`, if any. Must process rows in order,
  because matches are order-dependent based on how they are ordered (by id)
  in the database. Returns `nil` if no match found.
  """
  def find_matching(str) do
    Expensive.Repo.all(from cr in Expensive.CategoryRegex, order_by: cr.id)
    |> Enum.filter(&(Regex.compile!(&1.regex) |> Regex.match? str))
    |> Enum.take(1)
    |> List.first
  end
end
