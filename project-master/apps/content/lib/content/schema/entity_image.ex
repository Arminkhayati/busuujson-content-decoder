defmodule Content.Schema.EntityImage do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
    A module for EntityImage schema from entity_images table in database with five functions.
    Fields are

      field :type, :string
      field :size, :string
      field :link, :string
      belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_id, on_replace: :update
  """

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entity_images" do
    field :small, :string
    field :medium, :string
    field :large, :string
    field :xlarge, :string
    belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_key, references: :id, on_replace: :update
  end

  @fields ~w(small medium large xlarge)a
  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _root_struct: A %EntityImage{} struct as data.
      - params: A map of paramaters as changes for the given EntityImage schema.
    ## Examples
      iex> changeset = EntityImage.changeset(%EntityImage{small: "A small"}, %{large: "A large"})
      iex> changeset.changes
      %{large: "A large"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(image, params \\ %{})do
    image
    |> cast(params, @fields)
  end

end
