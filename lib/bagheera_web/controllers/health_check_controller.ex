defmodule BagheeraWeb.HealthCheckController do
  use BagheeraWeb, :controller

  def index(conn, _params) do
    response = %{
      status: "pass",
      version: to_string(Application.spec(:bagheera, :vsn))
    }

    render(conn, "index.json", response: response)
  end
end
