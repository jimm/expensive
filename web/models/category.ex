defmodule Expensive.Category do
  use Expensive.Web, :model

  schema "categories" do
    field :description, :string

    timestamps
  end

  @required_fields ~w(description)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:description, min: 1)
  end
end
