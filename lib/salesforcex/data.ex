defmodule Salesforcex.Data do
  alias Salesforcex.HTTP, as: HTTP
  require Poison

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def search(client, sosl_string) do
    HTTP.request(client, :get, "/search", %{q: sosl_string})
  end

  def search_by(client, field, value) do
    search(client, "FIND {#{value}} IN #{field} FIELDS")
  end

  # Docs
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_search.htm
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_search_parameterized.htm?search_text=parameterizedSearch
  def parameterized_search(client, params) do
    HTTP.request(client, :post, "/parameterizedSearch", %{}, params, ["Content-Type": "application/json"])
  end

  def get_sobject(client, type, id) do
    HTTP.request(client, :get, "/SObjectName/#{type}/#{id}")
  end

end
