defmodule Salesforcex.HTTP do
  use HTTPoison.Base
  require Poison

  def request(client, method, path, query \\ %{}, body \\ %{}, headers \\ [], options \\ []) do
    url = client.endpoint <> "/services/data/v" <> client.api_version <> path <> "?" <> URI.encode_query(query)
    headers = Keyword.merge(headers, [{"Authorization", "Bearer #{client.auth[:access_token]}"}])

    response = HTTPoison.request(method, url, Poison.encode!(body), headers, options)

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Poison.decode!(body)
      {_, error} ->
        {:error, error}
    end
  end

end
