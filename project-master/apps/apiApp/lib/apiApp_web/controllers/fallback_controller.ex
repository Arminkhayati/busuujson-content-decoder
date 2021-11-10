defmodule ApiAppWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ApiAppWeb, :controller

  @doc """
    Generate response in case of failure in getting list of lessons.
    ## Parameters

        - conn: A Plug.Conn struct.
        - A tuple represents error.
  """
  @spec call(Plug.Conn.t(), tuple) :: Plug.Conn.t()
  def call(conn, {:error, :lesson_list_failed})do
    conn
    |> put_status(500)
    |> json(%{error: "Could not get Lesson Lists"})
  end
  def call(conn, {:error, :lesson_fetch_failed})do
    conn
    |> put_status(500)
    |> json(%{error: "Could not get Lesson"})
  end
  def call(conn, {:error, :fetch_failed})do
    conn
    |> put_status(500)
    |> json(%{error: "Could not save Lesson"})
  end
  def call(conn, {:error, :save_failed})do
    conn
    |> put_status(500)
    |> json(%{error: "Could not save Lesson"})
  end

  def call(conn, {:error, :subunit_fetch_failed})do
    conn
    |> put_status(500)
    |> json(%{error: "Could not get subunit"})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MyApiWeb.ErrorView)
    |> render(:"404")
  end
end
