defmodule Downloader.Soundcloud.Track do
  alias Downloader.Utils

  @soundcloud_page_download_error_message "Error downloading soundcloud track page"
  @stream_id_search_error_message "Stream id not found"
  @stream_list_download_error_message "Error downloading track list json"
  @stream_list_decode_error_message "Invalid track list json"
  @stream_url_search_error_message "No stream url found"
  @track_download_error_message "Error downloading track"
  @stream_id_regex ~r/api.soundcloud.com%2Ftracks%2F([0-9]+)/
  @stream_list_property "http_mp3_128_url"

  def get(track_name, page_url, client_id) do
    create_track_folder()

    with {:ok, soundcloud_page} <- Utils.download(page_url, @soundcloud_page_download_error_message),
         {:ok, stream_id} <- Utils.regex_search(@stream_id_regex, soundcloud_page, @stream_id_search_error_message),
           stream_list_url <- stream_list_url(stream_id, client_id),
         {:ok, stream_list_json_string} <- Utils.download(stream_list_url, @stream_list_download_error_message),
         {:ok, stream_list} <- Utils.decode_json(stream_list_json_string, @stream_list_decode_error_message),
         {:ok, stream_url} <- stream_url(stream_list),
         {:ok, track} <- Utils.download(stream_url, @track_download_error_message) do
      save_track(track, track_name)
    else
      error -> error
    end
  end

  defp stream_list_url(stream_id, client_id) do
    "https://api.soundcloud.com/i1/tracks/#{stream_id}/streams?client_id=#{client_id}"
  end

  defp stream_url(stream_list) do
    if Map.has_key?(stream_list, @stream_list_property) do
      Map.fetch(stream_list, @stream_list_property)
    else
      {:error, @stream_url_search_error_message}
    end
  end

  defp create_track_folder do
    File.mkdir_p("tracks")
  end

  defp save_track(track, track_name) do
    path = "tracks/#{track_name}.mp3"
    File.write(path, track)
  end
end
