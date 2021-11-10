defmodule Content.Schema.Entity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @moduledoc """
    A module for Entity schema from entities table in database with four functions.
    Fields are

      field :entity_key, :string
      field :image, :string
      field :vocabulary, :boolean
      belongs_to :translation_map_id, Content.Schema.TranslationMap, foreign_key: :phrase, references: :id,  on_replace: :update
      has_one :other_image, Content.Schema.EntityImage, foreign_key: :entity_key, on_replace: :update
      has_many :videos, Content.Schema.EntityVideo, on_replace: :delete

  """
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entities" do
    field :entity_key, :string
    field :image, :string
    field :vocabulary, :boolean
    belongs_to :translation_map_id, Content.Schema.TranslationMap, foreign_key: :phrase, references: :id,  on_replace: :update
    has_one :other_image, Content.Schema.EntityImage, foreign_key: :entity_key, on_replace: :update
    has_many :videos, Content.Schema.EntityVideo, on_replace: :delete
  end


  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _entity: A %Entity{} struct as data.
      - params: A map of paramaters as changes for the given Entity schema.
    ## Examples
      iex> changeset = Entity.changeset(%Entity{vocabulary: "A vocabulary"}, %{image: "An image"})
      iex> changeset.changes
      %{image: "An image"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  @fields ~w(entity_key image vocabulary)a
  def changeset(_entity, params \\ %{})do
    Ecto.build_assoc(get_str(params.phrase), :enities)
    |> cast(params, @fields)
    |> unique_constraint(:entity_key, name: :entity_key_unique_constraint)
    |> cast_assoc(:videos, with: &Content.Schema.EntityVideo.changeset/2)
    |> cast_assoc(:other_image, with: &Content.Schema.EntityImage.changeset/2)
  end

  @doc """
  Gets a list of map of Entity params and calls changeset function on them then insert them in database.

    ## Parameters
      - list: A list of map of Entity params.

    ## Examples
      iex> Entity.to_db(%{vocabulary: "A vocabulary", image: "An image"})
      {:ok, %Entity{...}}

  """
  @spec to_db([map()]) :: {:ok, any()}
  | {:error, any()}
  | {:error, Ecto.Multi.name(), any(),
     %{required(Ecto.Multi.name()) => any()}}
  def to_db(list)do
    alias Content.Schema.Entity
    list
    |> filter_duplicates()
    |> Enum.map(&changeset(%Entity{}, &1))
    |> insert_all()
  end

  defp get_str(phrase)do
    alias Content.Schema.TranslationMap
    Repo.get_by(TranslationMap, str_key: phrase)
  end

  @doc """
  Gets a list of Entity maps and filter those are available in database.
  Returns list of unique schemas that aren't in database.
  """
  @spec filter_duplicates([map()]) :: [map()]
  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.entity_key not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    alias Content.Schema.Entity
    key_list = Enum.map(schemas, &(&1.entity_key))
    Repo.all(from e in Entity, where: e.entity_key in ^key_list, select: e.entity_key)
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
