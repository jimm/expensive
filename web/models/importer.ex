defmodule Expensive.Importer do

  import Expensive.Importer.Common
  alias Expensive.Repo
  alias Expensive.Check
  alias Expensive.Transaction
  alias Expensive.Importer.Type1
  alias Expensive.Importer.Type2
  alias Expensive.Importer.Type3
  alias Expensive.Importer.Peoples

  @txn_parsers %{
    Type1.header   => &Type1.parse/1,
    Type2.header   => &Type2.parse/1,
    Type3.header   => &Type3.parse/1,
    Peoples.first_row => &Peoples.parse/1
  }

  @doc """
  Import `file`, which is a CSV containing my bank's transactions. Handles
  multiple formats because my bank has changed its output format over time.
  """
  def transactions(file) do
    process_file(file, transform_func_from_headers(file))
  end

  @doc """
  Import `file`, which is a CSV containing check information. Links the
  checks to the corresponding transactions.

  Check files should be imported after the corresponding transaction files.
  """
  def checks(file) do
    process_file(file, &save_check/1)
  end

  defp process_file(file, row_func) do
    CSVLixir.read(file)
    |> Stream.map(fn(row) -> Task.async(fn -> row_func.(row) end) end)
    |> Stream.map(&(Task.await(&1)))
    |> Stream.run
    :ok
  end

  defp transform_func_from_headers(file) do
    first_row = CSVLixir.read(file)
    |> Stream.take(1)
    |> Enum.to_list
    |> List.first
    @txn_parsers[first_row]
  end

  def save_check([num, description, amount]) do
    save_check([num, description, amount, nil])
  end

  def save_check([num, description, amount, note]) when is_binary(num) do
    save_check([String.to_integer(num), description, amount, note])
  end
  def save_check([num, description, amount, note]) do
    amount_cents = money_str_to_int(amount)

    # If there is a corresponding transaction, then sanity-check the amount
    # and update the transaction's description to match this check's
    # description.
    txn = Repo.get_by(Transaction, check_num: num)
    if txn do
      true = (-amount_cents == txn.amount) # data integrity check
      cset = Transaction.changeset(txn, %{description: description})
      if cset.valid? do
        Repo.update!(cset)
      else
        raise "invalid transaction changeset: #{cset.errors}"
      end
    end

    # Create or update.
    category_id = assign_category(note)
    existing_check = Repo.get(Check, num)
    if existing_check == nil do
      Repo.insert!(%Check{id: num,
                          amount: amount_cents,
                          description: description,
                          transaction_id: txn && txn.id,
                          category_id: category_id, notes: note})
    else
      cset = Check.changeset(existing_check, %{description: description,
                                               category_id: category_id,
                                               notes: note})
      if cset.valid? do
        Repo.update!(cset)
      else
        raise "invalid check changeset: #{cset.errors}"
      end
    end
  end
end
