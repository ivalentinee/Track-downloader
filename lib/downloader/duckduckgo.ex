defmodule Downloader.Duckduckgo do
  alias Downloader.Utils

  @search_page_download_error_message 'Error downloading DuckDuckGo page'
  @result_search_error_message "No DuckDuckGo results found"
  @result_regex ~r/class="result__a".+href=".+(https.+soundcloud\.com.+)"/

  def find_soundcloud_url(track_name) do
    search_page_url = search_page_url(track_name)

    with {:ok, search_page} <- Utils.download(search_page_url, @search_page_download_error_message),
         {:ok, search_result} <- Utils.regex_search(@result_regex, search_page, @result_search_error_message) do
      {:ok, URI.decode(search_result)}
    else
      error -> error
    end
  end

  defp search_page_url(track_name) do
    query = %{q: "#{track_name} soundcloud"}
    encoded_query = URI.encode_query(query)

    "https://duckduckgo.com/html/?#{encoded_query}"
  end
end
