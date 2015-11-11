defmodule Expensive.Transaction do
  use Expensive.Web, :model

  schema "transactions" do
    field :year, :integer
    field :month, :integer
    field :day, :integer
    field :amount, :integer
    field :description, :string
    field :type, :string
    field :check_num, :integer
    field :notes, :string
    belongs_to :category, Expensive.Category

    timestamps
  end

  @required_fields ~w(year month day amount description)
  @optional_fields ~w(type check_num notes category_id)

  def date_str(txn) do
    "#{txn.year}-#{leading_zero(txn.month)}#{txn.month}-#{leading_zero(txn.day)}#{txn.day}"
  end

  def amount_str(txn), do: "$#{Float.to_string(-txn.amount/10.0, decimals: 2)}"

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_number(:year, greater_than: 1900)
    |> validate_number(:month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12)
    |> validate_number(:day, greater_than_or_equal_to: 1, less_than_or_equal_to: 31)
    |> validate_length(:description, min: 1)
    |> foreign_key_constraint(:category_id)
  end

  defp leading_zero(n) when n < 10, do: "0"
  defp leading_zero(_), do: ""
end
