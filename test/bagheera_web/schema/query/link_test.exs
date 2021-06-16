defmodule BagheeraWeb.Schema.Query.LinkTest do
  use BagheeraWeb.ConnCase, async: true
  import Bagheera.Factory

  describe "link" do
    defp opaque_id(id), do: Base.encode64("Link:#{id}")

    @query """
    query Link($id: ID!) {
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
        |> get("/graphql", query: @query, variables: %{id: opaque_id("123")})

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
        |> get("/graphql", query: @query, variables: %{id: opaque_id(link.id)})

      expected = %{
        "data" => %{
          "link" => %{
            "id" => opaque_id(link.id),
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
        edges {
          node {
            id
            hash
            url
          }
        },
        pageInfo {
          hasNextPage
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
              "hasNextPage" => false
            }
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
                "node" => %{
                  "id" => opaque_id(link1.id),
                  "hash" => link1.hash,
                  "url" => link1.url
                }
              },
              %{
                "node" => %{
                  "id" => opaque_id(link2.id),
                  "hash" => link2.hash,
                  "url" => link2.url
                }
              }
            ],
            "pageInfo" => %{
              "hasNextPage" => true
            }
          }
        }
      }

      assert expected == json_response(response, 200)
    end
  end
end
