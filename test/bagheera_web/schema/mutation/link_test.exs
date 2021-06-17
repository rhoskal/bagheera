defmodule BagheeraWeb.Schema.Mutation.LinkTest do
  use BagheeraWeb.ConnCase, async: true
  import Bagheera.Factory

  describe "create_link" do
    defp opaque_id(id), do: Base.encode64("Link:#{id}")

    @query """
    mutation CreateLink($link: CreateLinkInput!) {
      createLink(input: $link) {
        id
        hash
        url
      }
    }
    """

    test "should return an error when no url is provided" do
      response =
        build_conn()
        |> post("/api", query: @query, variables: %{link: %{"url" => ""}})

      assert %{
               "data" => %{
                 "createLink" => nil
               },
               "errors" => [
                 %{
                   "message" => "Create failed",
                   "details" => %{"url" => ["can't be blank"]}
                 }
               ]
             } = json_response(response, 200)
    end

    test "should create and return a link" do
      response =
        build_conn()
        |> post("/api", query: @query, variables: %{link: %{url: "https://abc.com"}})

      assert %{
               "data" => %{
                 "createLink" => %{
                   "url" => "https://abc.com"
                 }
               }
             } = json_response(response, 200)
    end
  end

  describe "update_link" do
    @query """
    mutation UpdateLink($link: UpdateLinkInput!) {
      updateLink(input: $link) {
            id
            hash
            url
      }
    }
    """

    test "should return an error for non-existent link" do
      response =
        build_conn()
        |> post("/api",
          query: @query,
          variables: %{link: %{id: opaque_id("99"), url: "http://abc.com"}}
        )

      assert %{
               "data" => %{
                 "updateLink" => nil
               },
               "errors" => [
                 %{
                   "message" => "Update failed",
                   "details" => "Link does not exist"
                 }
               ]
             } = json_response(response, 200)
    end

    test "should return an error given invalid input data" do
      orig_link = insert(:link)

      response =
        build_conn()
        |> post("/api",
          query: @query,
          variables: %{link: %{id: opaque_id(orig_link.id), url: ""}}
        )

      assert %{
               "data" => %{
                 "updateLink" => nil
               },
               "errors" => [
                 %{
                   "message" => "Update failed",
                   "details" => %{"url" => ["can't be blank"]}
                 }
               ]
             } = json_response(response, 200)
    end

    test "should update a link" do
      orig_link = insert(:link)

      response =
        build_conn()
        |> post("/api",
          query: @query,
          variables: %{link: %{id: opaque_id(orig_link.id), url: "http://www.bonzai.com"}}
        )

      expected = %{
        "data" => %{
          "updateLink" => %{
            "id" => opaque_id(orig_link.id),
            "hash" => orig_link.hash,
            "url" => "http://www.bonzai.com"
          }
        }
      }

      assert json_response(response, 200) == expected
    end
  end

  describe "delete_link" do
    @query """
    mutation DeleteLink($id: ID!) {
      deleteLink(id: $id) {
        id
      }
    }
    """

    test "should return an error for non-existent link" do
      response =
        build_conn()
        |> post("/api", query: @query, variables: %{id: opaque_id("99")})

      assert %{
               "data" => %{
                 "deleteLink" => nil
               },
               "errors" => [
                 %{
                   "message" => "Link does not exist"
                 }
               ]
             } = json_response(response, 200)
    end

    test "should delete a link" do
      link = insert(:link)

      response =
        build_conn()
        |> post("/api", query: @query, variables: %{id: opaque_id(link.id)})

      expected = %{
        "data" => %{
          "deleteLink" => %{
            "id" => opaque_id(link.id)
          }
        }
      }

      assert expected == json_response(response, 200)
    end
  end
end
