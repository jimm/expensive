defmodule Expensive.CategoryRegex do

  use Expensive.Web, :model
  import Ecto.Query, only: [from: 2]
  alias Expensive.Repo

  schema "category_regexes" do
    field :regex, :string
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(regex category_id)
  @optional_fields ~w()

  @doc """
  Finds the record matching `str`, if any. Must process rows in order,
  because matches are order-dependent based on how they are ordered (by id)
  in the database. Returns `nil` if no match found.
  """
  def find_matching(str) do
    Repo.all(from cr in __MODULE__, order_by: cr.id)
    |> Enum.filter(&(Regex.compile!(&1.regex) |> Regex.match? str))
    |> Enum.take(1)
    |> List.first
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:regex, min: 1)
  end
end
