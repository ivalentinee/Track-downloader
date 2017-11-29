defmodule Downloader do
  def main(args) do
    track_list_file_name = track_list_file_name(args)
    Downloader.TrackList.get(track_list_file_name)
  end

  defp track_list_file_name(args) do
    parsed_args = parse_args(args)
    List.first(parsed_args[:params])
  end

  defp parse_args(args) do
    {options, params, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    %{options: options, params: params}
  end
end
