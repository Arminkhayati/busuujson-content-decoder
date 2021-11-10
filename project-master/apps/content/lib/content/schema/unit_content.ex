defmodule Content.Schema.UnitContent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @fields ~w(title image1024 image2048)a
  @moduledoc """
    A module for UnitContent schema from unit_contents table in database with three functions.
    Fields are

      field :title, :string
      field :image1024, :string
      field :image2048, :string
      belongs_to :unit, Content.Schema.Unit, on_replace: :update

  """
  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "unit_contents" do
    field :title, :string
    field :image1024, :string
    field :image2048, :string
    belongs_to :unit, Content.Schema.Unit, on_replace: :update
  end


  @doc """
    Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _unit_content: A %Unit{} struct as data.
      - params: A map of paramaters as changes for the given unit content schema.
    ## Examples
      iex> changeset = UnitContent.changeset(%UnitContent{title: "A title"}, %{image2048: "A url"})
      iex> changeset.changes
      %{image2048: "A url"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(_unit_content, params \\ %{})do
    Ecto.build_assoc(get_unit(params.unit), :content)
    |> cast(params, @fields)
    |> unique_constraint(:unit, name: :unit_contents_unit_id_index)
  end


  @doc """
  Gets a map of unit content params and calls changeset function on it then inserts it in database.

    ## Parameters
      - content: A map of unit content params.

    ## Examples
      iex> UnitContent.to_db(%{title: "A title", image1024: "A url"})
      {:ok, %UnitContent{...}}

  """
  @spec to_db(
  %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def to_db(content)do
    content = get_title(content)
    changeset(%__MODULE__{}, content)
    |> Repo.insert()
  end

  @doc """
  Sets title for unit content map.

    ## Parameters

      - content: Unit content map.

    ## Examples

      iex> UnitContent.get_title(%{...})
      %{title: "a title", ...}

  """
  @spec get_title(map) :: map
  def get_title(content)do
    import Ecto.Query
    title = Repo.one(from t in Content.Schema.TranslationMap, where: t.str_key == ^content.title, select: t.value)
    %{content | title: title}
  end

  @doc """
  Returns a unit selected by unit_id.

    ## Parameters

      - unit_id: A string unit_id.

    ## Examples

      iex> UnitContent.get_unit("unit_id")
      %Unit{}

  """
  @spec get_unit(String.t()) :: %Content.Schema.Unit{}
  def get_unit(unit_id)do
    Repo.get_by(Content.Schema.Unit, unit_id: unit_id)
  end


end
