defmodule Content.Schema.LessonContent do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Content.Repo
  alias Content.Schema.{Lesson, LessonContent, TranslationMap}
  @moduledoc """
    A module for LessonContent schema from lesson_contents table in database with four functions.
    Fields are

      belongs_to :lesson, Lesson, on_replace: :update
      field :title, :string
      field :image, :string
      field :image_svg, :string
      field :thumbnail_256, :string
      field :description, :string
      field :color1, :string
      field :color2, :string
      field :bucket, :integer
  """
  @fields ~w(title image image_svg thumbnail_256 description color1 color2 bucket)a

  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lesson_contents" do
    belongs_to :lesson, Lesson, on_replace: :update
    field :title, :string
    field :image, :string
    field :image_svg, :string
    field :thumbnail_256, :string
    field :description, :string
    field :color1, :string
    field :color2, :string
    field :bucket, :integer
  end

  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - content: A %LessonContent{} struct as data.
      - params: A map of paramaters as changes for the given LessonContent schema.
    ## Examples
      iex> changeset = LessonContent.changeset(%LessonContentcontent)
      iex> changeset.changes
      %{image: "An image"}

  """
  @spec changeset(map) ::  %Ecto.Changeset{}
  def changeset(content, params \\ %{})do
    content
    |> cast(params, @fields)
    |> unique_constraint(:unit, name: :lesson_contents_lesson_id_index)
  end

  @doc """
  Gets a map of LessonContent params and calls changeset function on it then inserts it in database.

    ## Parameters
      - content: A list of map of LessonContent params.

    ## Examples
      iex> LessonContent.to_db(%{title: "A title", icon: "An icon"})
      {:ok, %LessonContent{...}}

  """
  @spec to_db(
  %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def to_db(content) do
    id = get_lesson(content.lesson_id)
    changeset(%LessonContent{}, content)
    |> put_change(:lesson_id, id)
    |> Repo.insert()
  end

  @doc """
  Returns a lesson uuid id selected by an string lesson_id
    ## Parameters
      - lesson_id: An lesson_id

    ## Examples
      iex> LessonContent.get_lesson("lesson_enc_1_14_5")
      "c5ce6624-520b-4990-92b0-6009152e9d7c"
  """
  @spec get_lesson(String.t()) :: String.t()
  def get_lesson(lesson_id)do
    query = from l in Lesson, where: l.lesson_id == ^lesson_id, select: l.id
    Repo.one(query)
  end

  @doc """
  Returns a TranslationMap value field selected by an string str
    ## Parameters
      - str: An str.

    ## Examples
      iex> LessonContent.get_translation("str_20190205_21")
      "The speaker is happy because there is so much salt."
  """
  @spec get_translation(String.t()) :: String.t()
  def get_translation(str)do
    query = from t in TranslationMap, where: t.str_key == ^str, select: t.value
    Repo.one(query)
  end
end
