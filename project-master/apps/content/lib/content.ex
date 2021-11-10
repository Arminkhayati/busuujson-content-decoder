defmodule Content do
  @moduledoc """
  Documentation for content decoder.
  In General it gets a raw encoded format of a lesson json and decode and saves it in database.
  So it has only one higher order function.
  """

  @doc """
  Fetch function gets a raw encoded format of a lesson json then decode and save it in database.

  ## Parameters
    - json: A JSON formated string.
  ## Examples

      iex> Content.fetch(json)
      [ok: :ok]

  """

  @spec fetch(String.t()) :: [{:ok, :ok}]
  def fetch(json)do
    json
    |> Content.DataLoader.start()
  end



end
