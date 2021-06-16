defmodule Bagheera.Links.Link do
  @moduledoc """
  Link schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bagheera.Links.Hit
  alias Bagheera.StringGenerator

  schema "links" do
    field :hash, :string
    field :url, :string

    has_many :hits, Hit

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> generate_hash()
    |> unique_constraint([:hash])
  end

  @doc false
  def update_changeset(link, attrs) do
    link
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

  defp generate_hash(changeset) do
    put_change(changeset, :hash, StringGenerator.unique_string())
  end
end
