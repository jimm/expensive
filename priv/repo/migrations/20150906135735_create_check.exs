defmodule Expensive.Repo.Migrations.CreateCheck do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :transaction_id, references(:transactions)
      add :description, :text
      add :notes, :text

      timestamps
    end
    create index(:checks, [:transaction_id])

  end
end
