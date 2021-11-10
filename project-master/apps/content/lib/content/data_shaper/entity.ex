defmodule Content.DataShaper.Entity do
  alias Content.Schema.Entity
  import Content.Downloader, only: [download: 1]

  @moduledoc """
  At this module we do all works for decoding and saving entities in database.
  """

  @doc """
  It gets a json and take the entity_map part out and does the decoding.
  Returns the complete json.
    ## Parameters
      - json: A JSON formatted string.

    ## Examples
      iex> Entity.do_entity("{\"entity_map\":{...} , ...}")
      "{\"entity_map\":{...} , ...}"
  """
  @spec do_entity(String.t()) :: String.t()
  def do_entity(json = %{"entity_map" => data}) do
    data
    |> Enum.map(&map_to_schema/1)
    |> Entity.to_db()
    json
  end

  @doc false
  def map_to_schema({key, value})do
    %{
      vocabulary: value["vocabulary"],
      entity_key: key,
      image: download(value["image"]),
      phrase: value["phrase"],
      other_image: check_images(value["image_urls"]),
      videos: check_videos(value["video_urls"])
    }
  end
  @doc false
  def check_images(map) when map == %{}, do: %{}
  def check_images(map)do
    %{
      small: download(map["S"]),
      medium: download(map["M"]),
      large: download(map["L"]),
      xlarge: download(map["XL"])
    }
  end

  @doc false
  def check_videos(map) when map == %{}, do: []
  def check_videos(map)do
    [
      %{type: "mp4",size: "S", link: download(map["mp4"]["S"])},
      %{type: "mp4",size: "M", link: download(map["mp4"]["M"])},
      %{type: "mp4",size: "L", link: download(map["mp4"]["L"])},
      %{type: "webm",size: "S", link: download(map["webm"]["S"])},
      %{type: "webm",size: "M", link: download(map["webm"]["M"])},
      %{type: "webm",size: "L", link: download(map["webm"]["L"])},
    ]
  end

end
