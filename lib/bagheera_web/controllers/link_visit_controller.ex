defmodule BagheeraWeb.LinkVisitController do
  use BagheeraWeb, :controller

  alias Bagheera.Links

  def show(conn, %{"hash" => hash}) do
    baggy_link = Links.get_link_by!(hash: hash)

    Links.create_visit(baggy_link)

    conn
    |> put_status(:moved_permanently)
    |> redirect(external: baggy_link.url)
  end
end
