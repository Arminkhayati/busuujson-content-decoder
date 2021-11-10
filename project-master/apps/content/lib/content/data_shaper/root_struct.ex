defmodule Content.DataShaper.RootStruct do
    alias Content.Schema.RootStruct
    @moduledoc """
    At this module we do all works for decoding and saving each unit part in database.
    """

    @doc """
    It gets a json and takes the outermost structure part out and does the decoding.
    Returns the complete json.

      ## Parameters
        - json: A JSON formatted string.

      ## Examples
        iex> RootStruct.do_root_struct("{\"structure\":{...} , ...}")
        "{\"structure\":{...} , ...}"
    """
    @spec do_root_struct(String.t()) :: String.t()
    def do_root_struct(json = %{"structure" => data})do
      data
      |> Enum.map(&map_to_schema/1)
      |> Enum.map(&set_unit(&1,json["id"]))
      |> RootStruct.to_db()
      json
    end

    @doc false
    def set_unit(map, unit)do
      %{map | unit: unit}
    end

    @doc false
    def map_to_schema(data)do
      %{
        premium: data["premium"],
        struct_id: data["id"],
        class: data["class"],
        type: data["type"],
        icon: data["icon"],
        unit: ""
      }
    end
end
