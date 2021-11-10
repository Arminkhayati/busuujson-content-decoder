defmodule Content.Schema.Unit do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Content.Repo
  alias Content.Schema.Lesson

  @moduledoc """
    A module for Unit schema from units table in database with three functions.
    Fields are
      belongs_to :lesson, Lesson, on_replace: :update
      field :unit_id, :string
      field :class, :string
      field :type, :string
      field :time_estimate, :integer
      has_one :content, Content.Schema.UnitContent, on_replace: :update
      has_many :root_structs, Content.Schema.RootStruct, on_replace: :delete

  """

  @doc """
    Defines Unit schema with these fields.
  """
  @derive {Jason.Encoder, only: [:unit_id, :class, :type, :time_estimate, :content, :root_structs]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "units" do
    belongs_to :lesson, Lesson, on_replace: :update

    field :unit_id, :string
    field :class, :string
    field :type, :string
    field :time_estimate, :integer
    has_one :content, Content.Schema.UnitContent, on_replace: :update
    has_many :root_structs, Content.Schema.RootStruct, on_replace: :delete
  end

  @fields ~w(unit_id class type time_estimate)a

  @doc """
    Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - units: A %Unit{} struct as data.
      - params: A map of paramaters as changes for the given unit schema.
    ## Examples
      iex> changeset = Unit.changeset(%Unit{type: "A type"}, %{class: "A class"})
      iex> changeset.changes
      %{class: "A class"}

  """

  @spec changeset(map) ::  %Ecto.Changeset{}
  def changeset(unit, params \\ %{})do
    unit
    |> cast(params, @fields)
    |> cast_assoc(:content, with: &Content.Schema.UnitContent.changeset/2)
    |> cast_assoc(:content, with: &Content.Schema.RootStruct.changeset/2)
    |> unique_constraint(:unit_id, name: :units_id_unique_constraint)
  end

  @doc """
  Gets a map of unit params and calls changeset function on it then inserts it in database.

    ## Parameters
      - unit: A map of unit params.

    ## Examples
      iex> Unit.to_db(%{unit_id: "An id", class: "A class"})
      {:ok, %Unit{...}}

  """
  @spec to_db(
  %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def to_db(unit)do
    id = get_lesson(unit.lesson_id)
    changeset(%__MODULE__{}, unit)
    |> put_change(:lesson_id, id)
    |> Repo.insert()
  end


  @doc """
  Returns an id of type uuid for a given string lesson_id.

    ## Parameters

      - lesson_id: A string lesson_id.

    ## Examples

      iex> Unit.get_lesson("lesson_id")
      "c5ce6624-520b-4990-92b0-6009152e9d7c"

  """
  @spec get_lesson(String.t()) ::  <<_::288>>
  def get_lesson(lesson_id)do
    query = from l in Lesson, where: l.lesson_id == ^lesson_id, select: l.id
    Repo.one(query)
  end


end
