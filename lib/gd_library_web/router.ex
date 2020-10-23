defmodule GDLibraryWeb.Router do
  use GDLibraryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GDLibraryWeb do
    pipe_through :api
  end
end
