defmodule Content.EditJson do

  @moduledoc false
  
  @source "/home/armin/Data/Development/Elixir/internet_prjoect/busuu/new"
  @level "Upper Intermediate B2"
  @destination "/home/armin/Desktop/new"
  def start()do
    Path.wildcard("#{@source}/#{@level}/*.json")
    |> Enum.map(&add_field(&1,"Beginner A1"))
  end

  def add_field(json_file, level)do
    File.read!(json_file)
    |> Poison.decode!()
    |> Map.put_new("level", level)
    |> Map.put_new("number", get_lesson_number(json_file))
    |> Poison.encode!()
    |> write(Path.basename(json_file, ".json") <> ".json")
  end

  def get_lesson_number(json_file)do
    json_file
    |> Path.basename()
    |> String.split("- ")
    |> List.first()
    |> Integer.parse()
    |> elem(0)
  end
  def write(json, file_name)do
    File.write!("#{@destination}/#{@level}/#{file_name}", json)
  end
end
