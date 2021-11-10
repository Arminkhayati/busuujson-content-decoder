defmodule ApiAppWeb.SubunitController do
  use ApiAppWeb, :controller
  import Content.Api.ContentHandler
  action_fallback ApiAppWeb.FallbackController

  @doc """
    Returns a specific subunit by id in json format.
  """
  def show(conn, %{"id" => id})do
    case get_subunit_by_id(id)do
      {:ok, subunit} -> render(conn, "show.json", %{subunit: subunit})
      _ -> {:error, :subunit_fetch_failed}
    end
  end


end
