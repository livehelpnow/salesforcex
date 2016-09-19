defmodule Salesforcex.HTTPTest do
  use ExUnit.Case
  doctest Salesforcex

  setup do
    client = Salesforcex.Client.new(endpoint: "https://eu11.salesforce.com", api_version: "36.0", auth: %{access_token: "00D0Y000000LzVO!ARgAQHa75IcTUUceUlOjj7.2nXasytlB56ZnQZiC7BE4HJCjqFIocSKGeQVEGzjL0mhC5t2YxVW_2gP7rGsM3inGVvkFE.vM"})
    {:ok, client: client}
  end

  test "post call", context do
    client = context[:client]

    body = %{"defaultLimit" => 10, "fields" => ["id", "firstName", "lastName"],
             "in" => "ALL", "overallLimit" => 100, "q" => "Test",
             "sobjects" => [%{"fields" => ["id", "NumberOfEmployees"], "limit" => 20,
                "name" => "Account"}, %{"name" => "Contact"}]}

    response = Salesforcex.HTTP.request(client, :post, "/parameterizedSearch", %{}, body, ["Content-Type": "application/json"])
    assert true
  end

  test "get call", context do
    client = context[:client]
    response = Salesforcex.HTTP.request(client, :get, "/search", %{q: "FIND {test.test@test.test} IN EMAIL FIELDS"})
    assert true
  end
end
