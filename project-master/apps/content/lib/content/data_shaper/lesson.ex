defmodule Content.DataShaper.Lesson do
  alias Content.Schema.Lesson
  @moduledoc """
  At this module we do all works for decoding and saving lesson data part in database.
  """
  @doc """
  It gets a json and takes the lesson data part out and does the decoding.
  Returns the complete json.

    ## Parameters
      - json: A JSON formatted string.

    ## Examples
      iex> Lesson.do_lesson("{\"id\":"An id" , ...}")
      "{\"content\":"An id", ...}"
  """
  @spec do_lesson(String.t()) :: String.t()
  def do_lesson(json)do
    json
    |> map_to_schema()
    |> Lesson.to_db()
    json
  end
  @doc false
  def map_to_schema(data)do
    %{
      lesson_id: data["id"],
      class: data["class"],
      type: data["type"],
      level: data["level"],
      number: data["number"],
    }
  end
end
