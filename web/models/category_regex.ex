defmodule Expensive.CategoryRegex do
  use Expensive.Web, :model

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
end
