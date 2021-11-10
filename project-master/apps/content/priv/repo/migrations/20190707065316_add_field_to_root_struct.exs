defmodule Content.Repo.Migrations.AddFieldToRootStruct do
  use Ecto.Migration

  def change do
    alter table(:root_structs)do
       add :premium, :boolean
    end
  end
end
