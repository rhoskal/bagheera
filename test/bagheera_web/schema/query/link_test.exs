defmodule BagheeraWeb.Schema.Query.LinkTest do
  use BagheeraWeb.ConnCase, async: true

  import Absinthe.Relay.Node, only: [to_global_id: 2]
  import Bagheera.Factory

  describe "link" do
    @query """
    query Link($id: LinkId!) {
      link(id: $id) {
        id
        hash
        url
      }
    }
    """

    test "should return an error for an unknown link" do
      response =
        build_conn()
        |> get("/graphql", query: @query, variables: %{id: to_global_id("Link", 123)})

      assert %{
               "data" => %{
                 "link" => nil
               },
               "errors" => [
                 %{
                   "message" => "Fetch failed",
                   "details" => "Link does not exist"
                 }
               ]
             } = json_response(response, 200)
    end

    test "should return a link" do
      link = insert(:link)

      response =
        build_conn()
        |> get("/graphql", query: @query, variables: %{id: to_global_id("Link", link.id)})

      expected = %{
        "data" => %{
          "link" => %{
            "id" => to_global_id("Link", link.id),
            "hash" => link.hash,
            "url" => link.url
          }
        }
      }

      assert expected == json_response(response, 200)
    end
  end

  describe "links" do
    @query """
    query Links {
      links(first: 2) {
        totalCount
        edges {
          cursor
          node {
            id
            hash
            url
          }
        },
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
      }
    }
    """

    test "should return an empty list" do
      response =
        build_conn()
        |> get("/graphql", query: @query)

      expected = %{
        "data" => %{
          "links" => %{
            "edges" => [],
            "pageInfo" => %{
              "endCursor" => nil,
              "hasNextPage" => false,
              "hasPreviousPage" => false,
              "startCursor" => nil
            },
            "totalCount" => 0
          }
        }
      }

      assert expected == json_response(response, 200)
    end

    test "should return a paginated list of links" do
      [link1, link2, _] = insert_list(3, :link)

      response =
        build_conn()
        |> get("/graphql", query: @query)

      expected = %{
        "data" => %{
          "links" => %{
            "edges" => [
              %{
                "cursor" => to_global_id("arrayconnection", 0),
                "node" => %{
                  "id" => to_global_id("Link", link1.id),
                  "hash" => link1.hash,
                  "url" => link1.url
                }
              },
              %{
                "cursor" => to_global_id("arrayconnection", 1),
                "node" => %{
                  "id" => to_global_id("Link", link2.id),
                  "hash" => link2.hash,
                  "url" => link2.url
                }
              }
            ],
            "pageInfo" => %{
              "endCursor" => to_global_id("arrayconnection", 1),
              "hasNextPage" => true,
              "hasPreviousPage" => false,
              "startCursor" => to_global_id("arrayconnection", 0)
            },
            "totalCount" => 3
          }
        }
      }

      assert expected == json_response(response, 200)
    end
  end
end
