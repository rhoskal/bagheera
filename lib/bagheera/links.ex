defmodule Bagheera.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Bagheera.Repo
  alias Bagheera.Links.{Hit, Link}

  @doc """
  Returns the list of links.

  ## Examples

      iex> all_links()
      [%Link{}, ...]

  """
  def all_links(), do: Repo.all(Link)

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
  Creates a view hit for a given link.

  ## Examples

      iex> create_hit(link)
      {:ok, %Hit{}}

      iex> create_hit(link)
      {:error, %Ecto.Changeset{}}

  """
  def create_hit(%Link{} = link, attrs \\ %{}) do
    %Hit{}
    |> Hit.changeset(attrs)
    |> Ecto.Changeset.put_change(:link_id, link.id)
    |> Repo.insert()
  end

  @doc """
  Returns a list of hits for a given link.

  ## Examples

      iex> get_all_link_hits()
      [%Link{}, ...]

  """
  def get_all_link_hits(id) do
    query =
      from(h in Hit,
        preload: [:link],
        where: h.link_id == ^id,
        order_by: [desc: :inserted_at]
      )

    Repo.all(query)
  end

  @doc """
  Returns hit count for a given link.

  ## Examples

      iex> link_hit_count(1)
      0

  """
  def link_hit_count(id) do
    query =
      from(h in Hit,
        where: h.link_id == ^id,
        select: count(h.id)
      )

    Repo.one(query)
  end
end
