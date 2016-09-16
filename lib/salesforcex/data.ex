defmodule Salesforcex.Data do
  use HTTPoison.Base
  require Poison

  def process_url(url) do
    "https://" <> Application.get_env(:salesforcex, :instance) <> ".salesforce.com" <> "/services/data/" <> Application.get_env(:salesforcex, :version) <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def request(method, path, query \\ %{})

  def request(:get, path, query) do
    query_string = query |> URI.encode_query
    url = "#{path}?#{query_string}"
    response = get(url, %{"Authorization" => "Bearer #{Application.get_env(:salesforcex, :credentials)["access_token"]}"})

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        body
      {_, error} ->
        {:error, error}
    end
  end

  def request(:post, path, query, body) do
    query_string = query |> URI.encode_query
    url = "#{path}?#{query_string}"

    response = post(url, Poison.encode!(body), %{"Authorization" => "Bearer #{Application.get_env(:salesforcex, :credentials)["access_token"]}", "Content-Type" => "application/json"})

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        body
      {_, error} ->
        {:error, error}
    end
  end

  def search(sosl_string) do
    request(:get, "/search", %{q: sosl_string})
  end

  def search_by(field, email) do
    search("FIND {#{email}} IN #{field} FIELDS")
  end

  # Docs
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_search.htm
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_search_parameterized.htm?search_text=parameterizedSearch
  def parameterized_search(params) do
    request(:post, "/parameterizedSearch", %{}, params)
  end


end
