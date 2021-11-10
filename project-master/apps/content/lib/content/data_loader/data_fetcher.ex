defmodule Content.DataFetcher do

  @moduledoc """
  A module for sending request to a url, getting the response and parse the body.
  """

  @doc """
  This function sends request to a url, gets the response and parses the body
    ## Parameters
      - url: A url to get data content for example "https://cdn.busuu.com/units/fullscreen/unit_enc_1_11_4.json"

    ## Examples
      iex> DataFetcher.fetch("https://cdn.busuu.com/units/fullscreen/unit_enc_1_11_4.json")
      {:ok, %{...}}

  """
  @spec fetch(String.t()) :: tuple
  def fetch(url)do
    url
    |> HTTPoison.get()
    |> response_handler()
    # |> write_json()
  end
  # def write_json({_,content}), do: File.write!("#{__DIR__}/a.json", Poison.encode!(content))
  # def response_handler({:error, %{id: nil, reason: reason}})do
  #   {:error, reason}
  # end
  defp response_handler({_, %{body: body, status_code: code}})do
    {
      code |> check_error(),
      body |> Poison.Parser.parse!(%{})
    }
  end

  defp check_error(200), do: :ok
  defp check_error(_), do: :error
end
