defmodule Content.Downloader do
  alias Content.RemoteFileStreamer
  import System, only: [os_time: 0]
  import Path, only: [extname: 1]
  @upload_directory Application.get_env(:content, :uploads_directory)
  @moduledoc """
  We can download a file, write and hash it in this module. It contains only one function.

  """
  @doc """
  Gets a url and download, hash and saves the file.
  We do hashing for detecting duplicate files.
    ## Parameters
      - url: A file url to download for example - https://cdn.busuu.com/units/fullscreen/unit_enc_1_11_4_2048.jpg

    ## Examples
      iex> Downloader.download("https://cdn.busuu.com/units/fullscreen/unit_enc_1_11_4_2048.jpg")
      "1234567889901234.jpg"

  """
  @spec download(nil) :: nil
  @spec download(String.t()) :: String.t()
  def download(""), do: ""
  def download(nil), do: nil
  def download(url)do
    url
    # |> RemoteFileStreamer.stream()
    # |> process(url)
  end

  defp process(stream, url)do
    file = file_rename(os_time(), url)
    stream
    |> write(file)
    |> hash()
    |> check_file()
  end

  defp check_file({hash, file})do
    source = file_address(file)
    destonation = file_address(hash)
    if File.exists?(destonation)do
      File.rm!(source)
    else
      File.rename(source, destonation)
    end
    destonation
  end

  defp hash({:ok, file})do
    hash = File.stream!(file_address(file)) |> sha256()
    {file_rename(hash, file), file}
  end
  defp hash({error, file}), do: raise("Can't hash downloaded file : #{file} , error: #{inspect(error)}")

  defp sha256(chunks_enum)do
    chunks_enum
    |> Enum.reduce(
        :crypto.hash_init(:sha256),
        &(:crypto.hash_update(&2, &1))
    )
    |> :crypto.hash_final()
    |> Base.encode16(case: :lower)
  end

  defp write(stream, file)do
    write_stream = write_stream(file)
    result = stream
      |> Stream.into(write_stream)
      |> Stream.run()
    {result, file}
  end

  defp write_stream(file)do
    File.stream!(file_address(file), [:delayed_write])
  end

  defp file_rename(name, file_address)do
    "#{name}#{extname(file_address)}"
  end

  defp file_address(file)do
    dir = extname(file) |> _file_address()
    "#{dir}#{file}"
  end

  defp _file_address(".mp3"), do: "#{@upload_directory}/audio/"
  defp _file_address(".jpg"), do: "#{@upload_directory}/image/"
  defp _file_address(".png"), do: "#{@upload_directory}/image/"
  defp _file_address(".mp4"), do: "#{@upload_directory}/video/"
  defp _file_address(".webm"), do: "#{@upload_directory}/video/"
  defp _file_address(_), do: "#{@upload_directory}/other/"
  """
  read = File.stream!("/home/armin/Videos/out-1.ogv")
  write = File.stream!("/home/armin/Desktop/temp.ogv", [:delayed_write])
  read
  |> Stream.into(write)
  |> Stream.run()
  """

end
