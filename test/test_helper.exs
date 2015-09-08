ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Code.require_file("priv/repo/seeds.exs")
Ecto.Adapters.SQL.begin_test_transaction(Expensive.Repo)

