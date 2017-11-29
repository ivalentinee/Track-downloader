defmodule Downloader.TrackList do
  @track_download_timeout 7000

  def get(file_name) do
    with :ok <- file_exists?(file_name),
         {:ok, soundcloud_client_id} <- Downloader.Soundcloud.ClientId.get() do
      get_tracks_for_list(file_name, soundcloud_client_id)
      IO.puts("Done")
    else
      {:error, error} -> IO.puts(error)
    end
  end

  defp file_exists?(file_name) do
    if File.exists?(file_name) do
      :ok
    else
      {:error, "File \"#{file_name}\" not found"}
    end
  end

  defp get_tracks_for_list(file_name, soundcloud_client_id) do
    file_stream = File.stream!(file_name)
    Enum.each(file_stream, fn track_name -> get_track(track_name, soundcloud_client_id) end)
  end

  defp get_track(track_name, soundcloud_client_id) do
    track_name
    |> String.trim
    |> Downloader.Track.get(soundcloud_client_id)

    Process.sleep(@track_download_timeout)
  end
end
