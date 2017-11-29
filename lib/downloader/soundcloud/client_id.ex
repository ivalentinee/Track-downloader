defmodule Downloader.Soundcloud.ClientId do
  alias Downloader.Utils

  @soundcloud_url "https://soundcloud.com/"
  @soundcloud_page_download_error_message "Soundcloud is unavailable"
  @app_js_url_search_error_message "app.js url not found"
  @app_js_download_error_message 'Error downloading app.js'
  @client_id_search_error_message "Client id not found"
  @app_js_url_regex ~r/(https?:\/\/[^\/]+\/assets\/app[^\.]+\.js)/
  @client_id_regex ~r/client_id:"([0-9a-zA-Z]+)"/

  def get do
    with {:ok, soundcloud_page} <- Utils.download(@soundcloud_url, @soundcloud_page_download_error_message),
         {:ok, app_js_url} <- Utils.regex_search(@app_js_url_regex, soundcloud_page, @app_js_url_search_error_message),
         {:ok, app_js} <- Utils.download(app_js_url, @app_js_download_error_message) do
      Utils.regex_search(@client_id_regex, app_js, @client_id_search_error_message)
    else
      error -> error
    end
  end
end
