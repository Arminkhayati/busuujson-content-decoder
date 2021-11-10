defmodule Content.DataShaper.TranslationMap do
  alias Content.Schema.TranslationMap
  import Content.Downloader, only: [download: 1]

  @moduledoc """
  At this module we do all works for decoding and saving translation map part in database.
  """
  @doc """
  It gets a json and takes the translation map part out and does the decoding.
  Returns the complete json.

    ## Parameters
      - json: A JSON formatted string.

    ## Examples
      iex> TranslationMap.do_translation("{\"translation_map\":{...} , ...}")
      "{\"translation_map\":{...} , ...}"
  """
  @spec do_translation(String.t()) :: String.t()
  def do_translation(json = %{"translation_map" => data})do
    data
    |> Enum.map(&map_to_schema/1)
    |> TranslationMap.to_db()
    json
  end

  @doc false
  def map_to_schema({key, value})do
    audio = value["en"]["audio"]
    str_value = value["en"]["value"]
    has_audio = if(audio == nil, do: false, else: true)
    alt_value = value["en"]["alternative_values"]
    %{
      str_key: key,
      value: str_value,
      audio: download(audio),
      alternative_value: alt_value |> if(do: Enum.join(alt_value,", "), else: ""),
      has_audio: has_audio
    }
  end

end
