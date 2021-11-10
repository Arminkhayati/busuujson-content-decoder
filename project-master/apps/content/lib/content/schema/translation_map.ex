defmodule Content.Schema.TranslationMap do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @moduledoc """
    A module for Translation schema from translations table in database with four functions.
    Fields are

      field :str_key, :string
      field :value, :string
      field :audio, :string
      field :alternative_value, :string
      field :has_audio, :boolean
      has_many :enities, Content.Schema.Entity, foreign_key: :phrase, on_replace: :delete

  """
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "translations" do
    field :str_key, :string
    field :value, :string
    field :audio, :string
    field :alternative_value, :string
    field :has_audio, :boolean
    has_many :enities, Content.Schema.Entity, foreign_key: :phrase, on_replace: :delete
  end

  @doc """
    Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - schema: A %TranslationMap{} struct as data.
      - params: A map of paramaters as changes for the given TranslationMap schema.
    ## Examples
      iex> changeset = TranslationMap.changeset(%TranslationMap{value: "A value"}, %{audio: "A url"})
      iex> changeset.changes
      %{audio: "A url"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  @fields ~w(str_key value audio alternative_value has_audio)a
  def changeset(schema, params \\ %{})do
    schema
    |> cast(params, @fields)
    |> unique_constraint(:str_key, name: :trans_key_unique_constraint)
    # |> validate_required(@required_values)
  end

  @doc """
  Gets a list of map of TranslationMap params and calls changeset function on them then insert them in database.

    ## Parameters
      - schemas: A list of map of TranslationMap params.

    ## Examples
      iex> TranslationMap.to_db(%{value: "A value", audio: "A url"})
      {:ok, %TranslationMap{...}}

  """
  @spec to_db(
  %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) :: {:ok, any()}
  | {:error, any()}
  | {:error, Ecto.Multi.name(), any(),
     %{required(Ecto.Multi.name()) => any()}}
  def to_db(schemas)do
    alias Content.Schema.TranslationMap
    schemas
    |> filter_duplicates()
    |> Enum.map(&changeset(%TranslationMap{},&1))
    |> insert_all()
  end


  @doc """
  Gets a list of TranslationMap maps and filter those are available in database.
  Returns list of unique schemas that aren't in database.
  """
  @spec filter_duplicates([map()]) :: [map()]
  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.str_key not in selected end)
  end

  @doc """
  Gets a list of TranslationMap schemas and select all of them from database based on their str_key.
  Returns a list of str_key from database.
  """
  defp get_schemas(schemas)do
    import Ecto.Query
    alias Content.Schema.TranslationMap
    key_list = Enum.map(schemas, &(&1.str_key))
    Repo.all(from t in TranslationMap, where: t.str_key in ^key_list, select: t.str_key)
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
        {res, _} = Repo.insert(changeset)
        if(res == :error, do: Repo.rollback(:duplicate_translation_map))
      end)
    end)
  end


end
