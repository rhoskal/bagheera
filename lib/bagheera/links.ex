defmodule Bagheera.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Bagheera.Repo
  alias Bagheera.Links.{Link, Visit}

  @doc """
  Returns the list of links.

  ## Examples

      iex> all_links()
      [%Link{}, ...]

  """
  def all_links, do: Repo.all(Link)

  @doc """
  Gets a single link.

  Returns nil if the Link does not exist.

  ## Examples

      iex> get_link(123)
      %Link{}

      iex> get_link(456)
      nil

  """
  def get_link(id), do: Repo.get(Link, id)

  @doc """
  Gets a single link by the given params

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link_by!(hash: "61e2f")
      %Link{}

      iex> get_link_by!(hash: 42)
      ** (Ecto.NoResultsError)

  """
  def get_link_by!(params), do: Repo.get_by!(Link, params)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link("1abb3G")
      {:ok, %Link{}}

      iex> delete_link("1abb4F")
      {:error, :not_found}

  """
  def delete_link(id) do
    with %Link{} = link <- Repo.get(Link, id),
         {:ok, link} <- Repo.delete(link) do
      {:ok, link}
    else
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{source: %Link{}}

  """
  def change_link(%Link{} = link), do: Link.changeset(link, %{})

  @doc """
  Creates a view visit for a given link.

  ## Examples

      iex> create_visit(link)
      {:ok, %Visit{}}

      iex> create_visit(link)
      {:error, %Ecto.Changeset{}}

  """
  def create_visit(%Link{} = link, attrs \\ %{}) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> Ecto.Changeset.put_change(:link_id, link.id)
    |> Repo.insert()
  end

  @doc """
  Returns a list of visits for a given link.

  ## Examples

      iex> get_all_link_visits()
      [%Link{}, ...]

  """
  def get_all_link_visits(id) do
    query =
      from(v in Visit,
        preload: [:link],
        where: v.link_id == ^id,
        order_by: [desc: :inserted_at]
      )

    Repo.all(query)
  end

  @doc """
  Returns visit count for a given link.

  ## Examples

      iex> link_visit_count(1)
      0

  """
  def link_visit_count(id) do
    query =
      from(v in Visit,
        where: v.link_id == ^id,
        select: count(v.id)
      )

    Repo.one(query)
  end

  @doc """
  Returns the total number of links in the database.

  ## Examples

      iex> total_count_of_links()
      42

  """
  def total_count_of_links do
    query =
      from(l in Link,
        select: count(l.id)
      )

    Repo.one(query)
  end
end
