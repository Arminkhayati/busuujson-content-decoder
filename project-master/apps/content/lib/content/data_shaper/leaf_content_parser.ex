defmodule Content.DataShaper.LeafContentParser do
  alias Content.Schema.TranslationMap
  alias Content.Schema.Entity
  @moduledoc """
  Module for turning unit part section map to a new map compatible with map_to_json transforming functions.
  """
  @doc """
  Takse leaf struct content map and transform it to json compatible map.
  """
  @spec parse(map) :: map
  def parse(content)do
    content
    |> Enum.map(&start/1)
  end

  defp start({key, value}) when is_bitstring(value)do
    {key, check_value(value)}
  end
  defp start({key, value}) when is_map(value) or is_list(value)do
    result = Enum.map(value, &start/1)
    result = if is_tuple(List.first(result)), do: Map.new(result), else: result
    {key, result}
  end
  # defp start({key,value})do
  #   {key,value}
  # end
  defp start(value)when is_bitstring(value), do: check_value(value)
  defp start(value)when is_map(value) or is_list(value)do
    result = Enum.map(value, &start/1)
    if is_tuple(List.first(result)), do: Map.new(result), else: result
  end
  defp start(value), do: value

  defp check_value(str = "str_" <> _)do
    Content.Repo.get_by(TranslationMap, str_key: str)
    |> check_str()
  end
  defp check_value(entity = "entity_" <> _)do
    Content.Repo.get_by(Entity, entity_key: entity)
    |> Content.Repo.preload([:other_image,:videos,:translation_map_id])
    |> check_entity()
  end
  defp check_value(value)do
    value
  end


  defp check_entity(entity)do
    %{
      "image" => entity.image,
      "vocabulary" => entity.vocabulary,
      "phrase" => check_str(entity.translation_map_id),
      "images" => check_images(entity.other_image),
      "videos" => entity.videos |> Enum.map(&check_videos/1),
    }
  end

  defp check_videos([])do
    []
  end
  defp check_videos(videos)do
    %{
      "type" => videos.type,
      "size" => videos.size,
      "link" => videos.link,
    }
  end

  defp check_images(%{small: nil})do
    %{}
  end
  defp check_images(images)do
    %{
      "small" => images.small,
      "medium" => images.medium,
      "large" => images.large,
      "xlarge" => images.xlarge,
    }
  end

  defp check_str(str = %{has_audio: false, alternative_value: nil})do
    str.value
  end
  defp check_str(str = %{alternative_value: val}) when not is_nil(val)do
    %{
      "value" => str.value,
      "audio" => str.audio,
      "alternative_value" => String.split(str.alternative_value, ", ")
    }
  end
  defp check_str(str)do
    %{
      "value" => str.value,
      "audio" => str.audio,
      "alternative_value" => ""
    }
  end

end
