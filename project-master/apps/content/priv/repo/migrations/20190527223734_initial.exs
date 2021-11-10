defmodule Content.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:units, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :unit_id, :string
      add :class, :string
      add :type, :string
      add :time_estimate, :integer
    end

    create unique_index(:units, [:unit_id], name: :units_id_unique_constraint)

    create table(:unit_contents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :image1024, :string
      add :image2048, :string
      add :unit_id, references(:units, [column: :id, type: :uuid])
    end

    create unique_index(:unit_contents, [:unit_id])

    create table(:root_structs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :struct_id, :string
      add :class, :string
      add :type, :string
      add :icon, :string
      add :unit_id, references(:units, [column: :id, type: :uuid])
    end

    create unique_index(:root_structs, [:struct_id], name: :struct_id_unique_constraint)

    create table(:leaf_structs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :struct_id, :string
      add :class, :string
      add :type, :string
      add :content, :map
      add :root_id, references(:root_structs, [column: :id, type: :uuid])
    end

    create table(:translations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :str_key, :string
      add :value, :text
      add :audio, :string
      add :alternative_value, :string
      add :has_audio, :boolean
    end

    create unique_index(:translations, [:str_key], name: :trans_key_unique_constraint)

    create table(:entities, primary_key: false)do
      add :id, :uuid, primary_key: true
      add :entity_key, :string
      add :phrase, references(:translations, [column: :id, type: :uuid])
      add :image, :string
      add :vocabulary, :boolean
    end
    create unique_index(:entities, [:entity_key], name: :entity_key_unique_constraint)

    create table(:entity_images, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :entity_key, references(:entities, [column: :id, type: :uuid])
      add :small, :string
      add :medium, :string
      add :large, :string
      add :xlarge, :string
    end

    create table(:entity_videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :entity_id, references(:entities, [column: :id, type: :uuid])
      add :type, :string
      add :size, :string
      add :link, :string
    end

    create table(:lessons, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :lesson_id, :string
      add :type, :string
      add :class, :string
    end

    create unique_index(:lessons, [:lesson_id], name: :lesson_id_unique_constraint)

    alter table(:units)do
      add :lesson_id, references(:lessons, [column: :id, type: :uuid])
    end

    create table(:lesson_contents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :lesson_id, references(:lessons, [column: :id, type: :uuid])
      add :title, :text
      add :image, :string
      add :image_svg, :string
      add :thumbnail_256, :string
      add :description, :text
      add :color1, :string
      add :color2, :string
      add :bucket, :integer
    end

    create unique_index(:lesson_contents, [:lesson_id])

    alter table(:lessons)do
      add :level, :string
      add :number, :integer
    end

  end
end
