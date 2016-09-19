defmodule Salesforcex.OAuth2 do
  use OAuth2.Strategy

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: Application.get_env(:salesforcex, :client_id),
      client_secret: Application.get_env(:salesforcex, :client_secret),
      redirect_uri: Application.get_env(:salesforcex, :redirect_uri),
      site: Application.get_env(:salesforcex, :site),
      authorize_url: Application.get_env(:salesforcex, :authorize_endpoint) <> Application.get_env(:salesforcex, :authorize_path),
      token_url: Application.get_env(:salesforcex, :authorize_endpoint) <> Application.get_env(:salesforcex, :token_path)
    ])
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client())
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  def refresh_token! do
    grant_type = "refresh_token"
    refresh_token = Application.get_env(:salesforcex, :credentials)["refresh_token"]
    client_id = Application.get_env(:salesforcex, :client_id)
    client_secret = Application.get_env(:salesforcex, :client_secret)
    instance_url = Application.get_env(:salesforcex, :credentials)["instance_url"]
    token_path = Application.get_env(:salesforcex, :token_path)

    url = "#{instance_url}#{token_path}"

    body = {:form,
            [{:grant_type, grant_type},
             {:refresh_token, refresh_token},
             {:client_id, client_id},
             {:client_secret, client_secret}]}

    response = HTTPoison.post!(url, body)

    case response do
      %HTTPoison.Response{body: body, status_code: 200} ->
        body |> Poison.decode!
      _ ->
        {:error, response}
    end
  end

  def parse_token!(get_token_response) do
    get_token_response |> Map.get(:token) |> Map.get(:access_token) |> Poison.decode!
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
