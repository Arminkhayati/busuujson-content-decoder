defmodule Content.Schema.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  alias Content.Schema.{Unit, LessonContent}
  @moduledoc """
    A module for Lesson schema from lessons table in database with two functions.
    Fields are

      field :lesson_id, :string
      field :type, :string
      field :class, :string
      field :level, :string
      field :number, :integer
      has_many :units, Unit, on_replace: :delete
      has_one :lesson_content, LessonContent, on_replace: :update

  """

  @derive {Jason.Encoder, only: [:number, :level, :lesson_id, :class, :type, :units, :lesson_content]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lessons" do
    field :lesson_id, :string
    field :type, :string
    field :class, :string
    field :level, :string
    field :number, :integer
    has_many :units, Unit, on_replace: :delete
    has_one :lesson_content, LessonContent, on_replace: :update
  end

  @fields ~w(level number lesson_id type class)a
  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - lesson: A %Lesson{} struct as data.
      - params: A map of paramaters as changes for the given Lesson schema.
    ## Examples
      iex> changeset = Lesson.changeset(%Lesson{class: "A class"}, %{type: "A type"})
      iex> changeset.changes
      %{type: "A type"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(lesson, params \\ %{})do
    lesson
    |> cast(params, @fields)
    |> unique_constraint(:lesson_id, name: :lesson_id_unique_constraint)
  end

  @doc """
  Gets a map of Lesson params and calls changeset function on it then inserts it in database.

    ## Parameters
      - lesson: A map of Lesson params.

    ## Examples
      iex> Lesson.to_db(%{type: "A type", class: "A class"})
      {:ok, %Lesson{...}}

  """
  @spec to_db(map) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def to_db(lesson)do
    changeset(%__MODULE__{}, lesson)
    |> Repo.insert()
  end
end
