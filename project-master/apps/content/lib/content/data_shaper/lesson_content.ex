defmodule Content.DataShaper.LessonContent do
  alias Content.Schema.LessonContent
  import Content.Downloader, only: [download: 1]
  @moduledoc """
  At this module we do all works for decoding and saving lesson content part in database.
  """
  @doc """
  It gets a json and takes the lesson content part out and does the decoding.
  Returns the complete json.

    ## Parameters
      - json: A JSON formatted string.

    ## Examples
      iex> LessonContent.do_lesson_content("{\"content\":{...} , ...}")
      "{\"content\":{...} , ...}"
  """
  @spec do_lesson_content(String.t()) :: String.t()
  def do_lesson_content(json)do
    json
    |> map_to_schema()
    |> LessonContent.to_db()
    json
  end

  @doc false
  def map_to_schema(%{"content" => data, "id" => id})do
    %{
      title: LessonContent.get_translation(data["title"]),
      image: download(data["image"]),
      image_svg: download(data["image_svg"]),
      thumbnail_256: download(data["images"]["thumbnail_256"]),
      description: LessonContent.get_translation(data["description"]),
      color1: data["color_1"],
      color2: data["color_2"],
      bucket: data["bucket"],
      lesson_id: id
    }
  end

end
