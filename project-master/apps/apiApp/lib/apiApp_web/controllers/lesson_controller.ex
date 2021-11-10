defmodule ApiAppWeb.LessonController do
  use ApiAppWeb, :controller

  import Content.Api.ContentHandler
  action_fallback ApiAppWeb.FallbackController

  @moduledoc """
    This function has three functions for three api of application engaged with lessons.
    Fallbacks related to these actions are in `ApiAppWeb.FallbackController` module.
  """

  @doc """
    Returns lessons list in json format.
  """
  def index(conn, _params) do
    case get_lessons_list()do
      {:ok, lessons} -> render(conn, "index.json", %{lessons: lessons})
      _ -> {:error, :lesson_list_failed}
    end
  end

  @doc """
    Returns a specific lesson by id in json format.
  """
  def show(conn, %{"id" => id})do
    case get_lesson_by_id(id)do
      {:ok, lesson} -> render(conn, "show.json", %{lesson: lesson})
      _ -> {:error, :lesson_fetch_failed}
    end
  end

  @doc """
    Gets raw and encoded json format of lesson and decodes it then saves it in Database.
  """
  def create(conn, %{"data" => data})do
    case Content.fetch(data)do
      :ok -> render(conn, "create.json", %{status: :ok})
      error ->
        {:error, :save_failed}
    end
  end

end
