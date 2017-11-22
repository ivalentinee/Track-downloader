defmodule Downloader.TrackList do
  def get(file_name) do
    file_stream = File.stream!(file_name)
    Enum.each(file_stream, &get_track/1)
  end

  defp get_track(line) do
    line
    |> String.trim
    |> Downloader.Track.get
  end
end
