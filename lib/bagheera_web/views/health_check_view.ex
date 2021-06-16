defmodule BagheeraWeb.HealthCheckView do
  use BagheeraWeb, :view

  def render("index.json", %{response: response}) do
    %{status: response.status, version: response.version}
  end
end
