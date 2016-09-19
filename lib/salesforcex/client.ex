defmodule Salesforcex.Client do
  defstruct endpoint: nil, api_version: nil, auth: nil

  def new(endpoint: endpoint, api_version: api_version, auth: %{} = auth) do
    %__MODULE__{endpoint: endpoint, api_version: api_version, auth: auth}
  end

  def new(token_json: %{"access_token" => access_token, "instance_url" => instance_url} = token_json, api_version: api_version) do
    %__MODULE__{endpoint: instance_url, api_version: api_version, auth: %{access_token: access_token}}
  end
end
