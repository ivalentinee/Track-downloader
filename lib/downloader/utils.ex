defmodule Downloader.Utils do
  use HTTPoison.Base

  def download(url, error_message) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      _ ->
        {:error, error_message}
    end
  end

  def regex_search(regex, text, error_message) do
    regex_result = Regex.run(regex, text)

    if is_nil(regex_result) do
      {:error, error_message}
    else
      match = List.last(regex_result)
      {:ok, match}
    end
  end

  def decode_json(json_string, error_message) do
    case Poison.decode(json_string) do
      {:ok, json} -> {:ok, json}
      _ -> {:error, error_message}
    end
  end
end
