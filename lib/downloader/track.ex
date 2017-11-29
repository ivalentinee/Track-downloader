defmodule Downloader.Track do
  def get(track_name, soundcloud_client_id) do
    with {:ok, soundcloud_page_url} <- Downloader.Duckduckgo.find_soundcloud_url(track_name),
         :ok <- Downloader.Soundcloud.Track.get(track_name, soundcloud_page_url, soundcloud_client_id) do
      IO.puts("Success: \"#{track_name}\"")
    else
      {:error, error} -> IO.puts("Failure: \"#{track_name}\" — #{error}")
    end
  end
end
