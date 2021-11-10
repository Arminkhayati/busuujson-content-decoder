defmodule Content.Schema.EntityVideo do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
    A module for EntityVideo schema from entity_videos table in database with five functions.
    Fields are

      field :type, :string
      field :size, :string
      field :link, :string
      belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_id, on_replace: :update
  """
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entity_videos" do
    field :type, :string
    field :size, :string
    field :link, :string
    belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_id, on_replace: :update
  end

  @fields ~w(type size link)a
  @doc """
  Applies the given params as changes for the given data. Returns a changeset.

    ## Parameters
      - _root_struct: A %EntityVideo{} struct as data.
      - params: A map of paramaters as changes for the given EntityVideo schema.
    ## Examples
      iex> changeset = EntityVideo.changeset(%EntityVideo{type: "A type"}, %{size: "A size"})
      iex> changeset.changes
      %{size: "A size"}

  """
  @spec changeset(
    Ecto.Schema.t(),
    %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid
  ) ::  %Ecto.Changeset{}
  def changeset(video, params \\ %{})do
    IO.inspect(video)
    video
    |> cast(params, @fields)
  end
end
