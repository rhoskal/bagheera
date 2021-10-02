defmodule BagheeraWeb.Schema.Query.NodeTest do
  use BagheeraWeb.ConnCase, async: true

  import Absinthe.Relay.Node, only: [to_global_id: 2]
  import Bagheera.Factory

  describe "node" do
    @query """
    query GlobalNode($id: ID!) {
      node(id: $id) {
        id
        ... on Link {
          hash
          url
        }
      }
    } 
    """

    test "should find a Link node given an id" do
      link = insert(:link)

      response =
        build_conn()
        |> get("/graphql", query: @query, variables: %{id: to_global_id("Link", link.id)})

      expected = %{
        "data" => %{
          "node" => %{
            "hash" => link.hash,
            "id" => to_global_id("Link", link.id),
            "url" => link.url
          }
        }
      }

      assert expected == json_response(response, 200)
    end

    test "should fail when trying to find a Link given an id" do
      response =
        build_conn()
        |> get("/graphql", query: @query, variables: %{id: to_global_id("Link", 123)})

      expected = %{
        "data" => %{
          "node" => nil
        }
      }

      assert expected == json_response(response, 200)
    end
  end
end
