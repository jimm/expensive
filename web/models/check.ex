defmodule Expensive.Check do
  use Expensive.Web, :model
  alias Expensive.Repo

  schema "checks" do
    field :description, :string
    field :notes, :string
    belongs_to :transaction, Expensive.Transaction
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(description)
  @optional_fields ~w(notes)

  def all_preloaded do
    Repo.all(from c in __MODULE__, preload: [:category, :transaction])
  end

  def amount(check) do
    if check.transaction_id, do: check.transaction.amount, else: nil
  end

  def amount_str(%Expensive.Check{transaction_id: nil} = _check), do: nil
  def amount_str(check), do: "$#{Float.to_string(-check.transaction.amount/10.0, decimals: 2)}"

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
