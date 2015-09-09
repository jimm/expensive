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
  @optional_fields ~w(type check_num notes)

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
