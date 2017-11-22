defmodule Downloader.Track do
  use HTTPoison.Base

  @soundcluod_client_id "3YnCkFCcm5cBfYqlXr3ufGY7k2izG1lv"

  def get(track_name) do
    try do
      soundcloud_page_url = soundcloud_page_url(track_name)
      soundcloud_stream_id = soundcloud_stream_id(soundcloud_page_url)
      soundcloud_stream_url = soundcloud_stream_url(soundcloud_stream_id)
      download_track(soundcloud_stream_url, track_name)
      IO.puts("Success: \"#{track_name}\"")
      Process.sleep(7000)
    rescue
      _ -> IO.puts("Failure: \"#{track_name}\"")
    end
  end

  defp soundcloud_page_url(track_name) do
    query = %{q: "#{track_name} soundcloud"}
    encoded_query = URI.encode_query(query)
    uri = "https://duckduckgo.com/html/?#{encoded_query}"
    {:ok, response} = HTTPoison.get(uri)
    duckuckgo_page = response.body
    regex = ~r/class="result__a".+href=".+(https.+soundcloud\.com.+)"/
    regex_result = Regex.run(regex, duckuckgo_page)
    soundcloud_url = List.last(regex_result)
    URI.decode(soundcloud_url)
  end

  defp soundcloud_stream_id(soundcloud_page_url) do
    {:ok, response} = HTTPoison.get(soundcloud_page_url)
    soundcloud_page = response.body
    regex = ~r/api.soundcloud.com%2Ftracks%2F([0-9]+)/
    regex_result = Regex.run(regex, soundcloud_page)
    List.last(regex_result)
  end

  defp soundcloud_stream_url(soundcloud_stream_id) do
    uri = "https://api.soundcloud.com/i1/tracks/#{soundcloud_stream_id}/streams?client_id=#{@soundcluod_client_id}"
    {:ok, response} = HTTPoison.get(uri)
    json = Poison.decode!(response.body)
    json["http_mp3_128_url"]
  end

  defp download_track(soundcloud_stream_url, track_name) do
    {:ok, response} = HTTPoison.get(soundcloud_stream_url)
    path = "tracks/#{track_name}.mp3"
    File.mkdir_p("tracks")
    File.write(path, response.body)
  end
end
