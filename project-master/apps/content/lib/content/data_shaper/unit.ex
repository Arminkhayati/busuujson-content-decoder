defmodule Content.DataShaper.Unit do
  alias Content.Schema.Unit
  @moduledoc """
  At this module we do all works for decoding and saving each unit data part in database.
  """
  @doc """
  It gets a json and takes each unit data part out and does the decoding.
  Returns the complete json.

    ## Parameters
      - json: A JSON formatted string.
      - lesson_id: The lesson id that unit belongs to.

    ## Examples
      iex> Unit.do_unit("{\"id\":"An id" , ...}","a_lesson_id")
      "{\"id\":"An id" , ...}"
  """
  @spec do_unit(String.t(), String.t()) :: String.t()
  def do_unit(json, lesson_id)do
    json
    |> map_to_schema(lesson_id)
    |> Unit.to_db()
    json
  end

  def map_to_schema(data, lesson_id)do
    %{
      unit_id: data["id"],
      class: data["class"],
      type: data["type"],
      time_estimate: data["time_estimate"],
      lesson_id: lesson_id
    }
  end
end
