defmodule Bagheera.LinksTest do
  use Bagheera.DataCase
  import Bagheera.Factory

  alias Bagheera.Links
  alias Bagheera.Links.{Link, Visit}

  describe "links" do
    @valid_attrs %{url: "http://zipbooks.com"}
    @update_attrs %{url: "https://zipbooks.com"}
    @invalid_attrs %{url: nil}

    test "all_links/0 returns all links" do
      links = insert_pair(:link)

      assert Links.all_links() == links
    end

    test "total_count_of_links/0" do
      links = insert_list(3, :link)

      assert Links.total_count_of_links() == length(links)
    end

    test "get_link/1 returns the link with given hash" do
      link = insert(:link)

      assert Links.get_link(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Links.create_link(@valid_attrs)
      assert link.url == Map.get(@valid_attrs, :url)
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      orig_link = insert(:link)

      assert {:ok, %Link{} = updated_link} = Links.update_link(orig_link, @update_attrs)
      assert orig_link.hash == updated_link.hash
      assert updated_link.url == Map.get(@update_attrs, :url)
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = insert(:link)

      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = insert(:link)

      assert {:ok, %Link{}} = Links.delete_link(link.id)
      refute Links.get_link(link.id)
    end

    test "change_link/1 returns a link changeset" do
      link = insert(:link)

      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end

  describe "visits" do
    test "create_visit/1 records a link view visit" do
      link = insert(:link)

      assert {:ok, %Visit{}} = Links.create_visit(link)
    end

    test "create_visit/1 fails because of foreign key constraint" do
      link = %Link{id: 42, url: "http://www.abc123.com"}

      {:error, %Ecto.Changeset{} = changeset} = Links.create_visit(link)

      assert %{
               errors: [
                 link_id:
                   {"does not exist",
                    [constraint: :foreign, constraint_name: "visits_link_id_fkey"]}
               ]
             } = changeset
    end

    test "get_all_link_visits/1 returns all visits for a given link" do
      link = insert(:link)
      Links.create_visit(link)

      assert [%Visit{}] = Links.get_all_link_visits(link.id)
    end
  end
end
