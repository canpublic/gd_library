defmodule GDLibraryWeb.Router do
  use GDLibraryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GDLibraryWeb do
    pipe_through :api

    get("/request", BookRequestController, :index)
    get("/request/:id", BookRequestController, :show)
    post("/request", BookRequestController, :create)
    delete("/request/:id", BookRequestController, :delete)
  end
end
