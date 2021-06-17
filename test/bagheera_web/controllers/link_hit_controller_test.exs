defmodule BagheeraWeb.LinkHitControllerTest do
  use BagheeraWeb.ConnCase
  import Bagheera.Factory

  test "should perform a 301 redirect given a valid hash", %{conn: conn} do
    link = insert(:link)
    response = get(conn, Routes.link_hit_path(conn, :show, link.hash))

    assert redirected_to(response, :moved_permanently) =~ link.url
  end

  test "should return a 404 given an invalid hash", %{conn: conn} do
    assert_error_sent :not_found, fn ->
      get(conn, Routes.link_hit_path(conn, :show, "/bogus-hash!"))
    end
  end
end
