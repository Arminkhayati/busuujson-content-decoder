defmodule Content.Schema.LeafStruct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @fields ~w(struct_id class type content)a
  @moduledoc """
    A module for LeafStruct schema from leaf_structs table in database with five functions.
    Fields are

      field :struct_id, :string
      field :class, :string
      field :type, :string
      field :content, :map
      belongs_to :root_struct_id, Content.Schema.RootStruct, foreign_key: :root_id, references: :id,  on_replace: :update

  """
  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "leaf_structs" do
    field :struct_id, :string
    field :class, :string
    field :type, :string
    field :content, :map
    belongs_to :root_struct_id, Content.Schema.RootStruct, foreign_key: :root_id, references: :id,  on_replace: :update
  end

  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _root_struct: A %LeafStruct{} struct as data.
      - params: A map of paramaters as changes for the given LeafStruct schema.
    ## Examples
      iex> changeset = LeafStruct.changeset(%LeafStruct{class: "A class"}, %{type: "A type"})
      iex> changeset.changes
      %{type: "A type"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(_leaf, params \\ %{})do
    Ecto.build_assoc(get_root(params.root_id), :leafs)
    |> cast(params, @fields)
  end

  @doc """
  Gets a list of map of LeafStruct params and calls changeset function on them then insert them in database.

    ## Parameters
      - leafs: A list of map of LeafStruct params.

    ## Examples
      iex> LeafStruct.to_db(%{type: "A type", class: "A class"})
      {:ok, %LeafStruct{...}}

  """
  @spec to_db([map])
  :: {:ok, any()}
  | {:error, any()}
  | {:error, Ecto.Multi.name(), any(),
     %{required(Ecto.Multi.name()) => any()}}
  def to_db(leafs)do
    leafs
    |> filter_duplicates()
    |> Enum.map(&changeset(%__MODULE__{}, &1))
    |> insert_all()
  end

  @doc """
  Returns a root struct selected by a root struct id
    ## Parameters
      - struct_id: A root struct id

    ## Examples
      iex> LeafStruct.get_unit("activity_enc_1_11_4_1")
      %RootStruct{...}
  """
  @spec get_root(String.t()) :: %Content.Schema.RootStruct{}
  def get_root(struct_id)do
    Repo.get_by(Content.Schema.RootStruct, struct_id: struct_id)
  end

  @doc """
  Gets a list of LeafStruct maps and filter those are available in database.
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
    Enum.map(schemas, fn %{root_id: root_id, struct_id: struct_id} ->
      root_id = get_root(root_id).id
      Repo.one(from ls in __MODULE__, where: ls.root_id == ^root_id and ls.struct_id == ^struct_id, select: ls.struct_id)
    end)

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
