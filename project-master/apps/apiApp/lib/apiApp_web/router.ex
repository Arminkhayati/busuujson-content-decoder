defmodule ApiAppWeb.Router do
  use ApiAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ApiAppWeb do
    pipe_through :api
    get "/lessons" , LessonController, :index
    get "/lessons/:id", LessonController, :show
    post "/lessons", LessonController, :create
    get "/lessons/subunit/:id", SubunitController, :show
  end
end
