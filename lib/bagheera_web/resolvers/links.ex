defmodule BagheeraWeb.Resolvers.Links do
  @moduledoc """
  Provides resolver functions for Link queries & mutations
  """

  alias Absinthe.Relay.Connection
  alias Bagheera.Links

  def get_link(_parent, %{id: id}, _resolution) do
    with %Links.Link{} = link <- Links.get_link(id),
         hits <- Links.link_hit_count(link.id) do
      {:ok, Map.put(link, :hits, hits)}
    else
      _ ->
        {
          :error,
          message: "Fetch failed", details: "Link does not exist"
        }
    end
  end

  def all_links(_parent, args, _resolution) do
    Links.all_links()
    |> Connection.from_list(args)
  end

  def create_link(_parent, %{input: %{} = params}, _resolution) do
    case Links.create_link(params) do
      {:error, changeset} ->
        {
          :error,
          message: "Create failed", details: error_details(changeset)
        }

      {:ok, _} = success ->
        success
    end
  end

  def update_link(_parent, %{input: %{} = params}, _resolution) do
    with %Links.Link{} = link <- Links.get_link(params.id),
         {:ok, _} = success <- Links.update_link(link, params) do
      success
    else
      nil ->
        {
          :error,
          message: "Update failed", details: "Link does not exist"
        }

      {:error, changeset} ->
        {
          :error,
          message: "Update failed", details: error_details(changeset)
        }
    end
  end

  def delete_link(_parent, %{id: id}, _resolution) do
    case Links.delete_link(id) do
      {:error, :not_found} ->
        {:error, "Link does not exist"}

      {:ok, _} = success ->
        success
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
