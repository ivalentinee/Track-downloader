defmodule Downloader do
  def main(args) do
    parsed_args = parse_args(args)
    file_name = List.first(parsed_args[:params])
    Downloader.TrackList.get(file_name)
  end

  defp parse_args(args) do
    {options, params, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    %{options: options, params: params}
  end
end
