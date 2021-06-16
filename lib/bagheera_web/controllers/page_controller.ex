defmodule BagheeraWeb.PageController do
  use BagheeraWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
