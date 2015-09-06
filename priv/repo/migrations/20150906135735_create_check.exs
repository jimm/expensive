defmodule Expensive.Repo.Migrations.CreateCheck do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :description, :text
      add :transaction_id, references(:transactions)

      timestamps
    end
    create index(:checks, [:transaction_id])

  end
end
