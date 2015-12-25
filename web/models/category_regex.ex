defmodule Expensive.CategoryRegex do

  use Expensive.Web, :model

  schema "category_regexes" do
    field :regex, :string
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(regex category_id)
  @optional_fields ~w()

  @doc """

  Finds the CategoryRegex record matching `str`, if any. The list of
  cateogry_regexes should be sorted by the order in which they should be
  applied for searching.

  Returns `nil` if no match found.

  """
  def find_matching(category_regexes, str) do
    category_regexes
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
