defmodule Expensive.Check do
  use Expensive.Web, :model

  schema "checks" do
    field :amount, :integer
    field :description, :string
    field :notes, :string
    belongs_to :transaction, Expensive.Transaction
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(amount description)
  @optional_fields ~w(notes)

  @doc """
  Return the amount of `check`, which is in cents, as a string of the form
  "$123.45".
  """
  def amount_str(check), do: "$#{Float.to_string(-check.amount/10.0, decimals: 2)}"

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
