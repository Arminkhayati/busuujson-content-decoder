defmodule Content.Api.ContentHandler do

  alias Content.Schema.Lesson
  alias Content.Schema.RootStruct
  alias Content.Repo

  @moduledoc """
  An module for a few library api's to work with lessons.

  """

  @doc """
  Gets a lesson id and returns a full lesson with that id.

    ## Parameters
      - id: A lesson id.

    ## Examples
      iex> ContentHandler.get_lesson_by_id("lesson_enc_1_14_5")
      %Lesson{...}
  """
  @spec get_lesson_by_id(String.t()) :: %Content.Schema.Lesson{}
  def get_lesson_by_id(id)do
    result = Repo.get_by(Lesson, lesson_id: id)
    |> Repo.preload([:lesson_content,
              {:units, :content},
              {:units, :root_structs},
              {:units, [{:root_structs, :leafs}]}
              ])
    {:ok, result}
  end

  @doc """
  Returns a list of lessons.
    ## Examples
      iex> ContentHandler.get_lessons_list()
      [%{...}, %{...}, ...]
  """
  @spec get_lessons_list() :: [map()]
  def get_lessons_list()do
    Repo.all(Lesson)
    |> Repo.preload([:lesson_content,
                      {:units, :content},
                      {:units, :root_structs}
                      ])
    |> case  do
      [%Lesson{} | _] = lessons ->
        result = lessons |> Enum.map(&to_map/1)
        {:ok, result}
      _ -> {:error, :lesson_table}
    end
  end

  def get_subunit_by_id(id)do
    result = Repo.get_by(RootStruct, struct_id: id)
    |> Repo.preload([:leafs])
    {:ok, result}
  end







  #######################################

  defp to_map(lesson)do
    _to_map(lesson)
    |> Map.put(:lesson_content, _to_map(lesson.lesson_content))
    |> Map.put(:units, Enum.map(lesson.units, &do_unit/1))
  end

  defp do_unit(unit)do
    IO.puts("unitttttttttiiiiiiiiiii")
    unit
    |> _to_map()
    |> Map.put(:content, _to_map(unit.content))
    |> Map.put(:root_structs, root_structs_to_map(unit.root_structs))
  end

  defp root_structs_to_map(root_structs)do
    root_structs |> Enum.map(&_to_map/1)
  end


  @schema_meta_fields [:__meta__, :id]
  defp _to_map(struct) do
    association_fields = struct.__struct__.__schema__(:associations)
    waste_fields = association_fields ++ @schema_meta_fields
    struct |> Map.from_struct |> Map.drop(waste_fields)
  end


end
