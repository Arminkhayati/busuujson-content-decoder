defmodule Content.Schema.RootStruct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @moduledoc """
    A module for RootStruct schema from root_structs table in database with five functions.
    Fields are

      field :struct_id, :string
      field :class, :string
      field :type, :string
      field :icon, :string
      field :premium, :boolean
      belongs_to :unit, Content.Schema.Unit, on_replace: :update
      has_many :leafs, Content.Schema.LeafStruct, foreign_key: :root_id, on_replace: :delete

  """

  @derive {Jason.Encoder, only: [:struct_id, :class, :type, :icon, :leafs]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "root_structs" do
    field :struct_id, :string
    field :class, :string
    field :type, :string
    field :icon, :string
    field :premium, :boolean
    belongs_to :unit, Content.Schema.Unit, on_replace: :update
    has_many :leafs, Content.Schema.LeafStruct, foreign_key: :root_id, on_replace: :delete
  end

  @fields ~w(struct_id class type icon premium)a
  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _root_struct: A %RootStruct{} struct as data.
      - params: A map of paramaters as changes for the given RootStruct schema.
    ## Examples
      iex> changeset = RootStruct.changeset(%RootStruct{class: "A class"}, %{icon: "An icon"})
      iex> changeset.changes
      %{icon: "An icon"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(_root_struct, params \\ %{})do
    Ecto.build_assoc(get_unit(params.unit), :root_structs)
    |> cast(params, @fields)
    |> cast_assoc(:leafs, with: &Content.Schema.LeafStruct.changeset/2)
    |> unique_constraint(:struct_id, name: :struct_id_unique_constraint)
  end

  @doc """
  Gets a list of map of RootStruct params and calls changeset function on them then insert them in database.

    ## Parameters
      - structs: A list of map of RootStruct params.

    ## Examples
      iex> RootStruct.to_db(%{type: "A type", icon: "An icon"})
      {:ok, %RootStruct{...}}

  """
  @spec to_db([map()]) :: {:ok, any()}
  | {:error, any()}
  | {:error, Ecto.Multi.name(), any(),
     %{required(Ecto.Multi.name()) => any()}}
  def to_db(structs)do
    structs
    |> filter_duplicates()
    |> Enum.map(&changeset(%__MODULE__{}, &1))
    |> insert_all()
  end

  @doc """
  Returns a Unit schema selected by an unit_id
    ## Parameters
      - unit_id: An unit_id

    ## Examples
      iex> RootStruct.get_unit("unit_enc_1_14_5")
      %Unit{...}
  """
  @spec get_unit(String.t()) :: %Content.Schema.Unit{}
  def get_unit(unit_id)do
    Repo.get_by(Content.Schema.Unit, unit_id: unit_id)
  end

  @doc """
  Gets a list of RootStruct maps and filter those are available in database.
  Returns list of unique schemas that aren't in database.
  """
  @spec filter_duplicates([map()]) :: [map()]
  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.struct_id not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    key_list = Enum.map(schemas, &(&1.struct_id))
    Repo.all(from rs in __MODULE__, where: rs.struct_id in ^key_list, select: rs.struct_id)
  end


  @doc """
  Inserts all data in a single transaction.
  If one insertion fails transaction will be rolled back.
  """
  @spec insert_all([%Ecto.Changeset{}])
  ::  {:ok, any()}
  | {:error, any()}
  | {:error, Ecto.Multi.name(), any(),
     %{required(Ecto.Multi.name()) => any()}}
  def insert_all(data)do
    Repo.transaction(fn ->
      Enum.each(data, fn changeset ->
        {res, err} = Repo.insert(changeset)
        if(res == :error, do: Repo.rollback(err))
      end)
    end)
  end

end
