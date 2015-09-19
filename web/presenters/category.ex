defmodule Expensive.Presenters.Category do
  
  @moduledoc """
  Retrieve Category models as needed for presentation to the user.
  """
  
  def for_menu(categories) do
    [{"", nil}] ++ (categories
                    |> Enum.map(&({&1.description, &1.id})))
  end
end
