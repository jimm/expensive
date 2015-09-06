defmodule Expensive.Router do
  use Expensive.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Expensive do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/categories", CategoryController
    resources "/category_regexes", CategoryRegexController
    resources "/transactions", TransactionController
    resources "/checks", CheckController
  end


  # Other scopes may use custom stacks.
  # scope "/api", Expensive do
  #   pipe_through :api
  # end
end
