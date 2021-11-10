defmodule Content.DataShaper.UnitContent do
  alias Content.Schema.UnitContent
  import Content.Downloader, only: [download: 1]

  @moduledoc """
  At this module we do all works for decoding and saving each unit content part in database.
  """
  @doc """
  It gets a json and takes each unit content part out and does the decoding.
  Returns the complete json.

    ## Parameters
      - json: A JSON formatted string.

    ## Examples
      iex> UnitContent.do_unit_content("{\"content\":{...} , ...}")
      "{\"content\":{...} , ...}"
  """
  @spec do_unit_content(String.t()) :: String.t()
  def do_unit_content(json = %{"content" => data})do
    data
    |> map_to_schema()
    |> set_unit(json)
    |> UnitContent.to_db()
    json
  end
  @doc false
  def set_unit(content, json)do
    Map.put_new(content, :unit, json["id"])
  end
  @doc false
  def map_to_schema(data) do
    %{
      title: data["title"],
      image1024: download(data["images"]["tile_1024"]),
      image2048: download(data["images"]["fullscreen_2048"]),
    }
  end

end
