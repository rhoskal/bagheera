defmodule Bagheera.ReleaseTasks do
  @moduledoc """
  Provides the ability run mix tasks on release after build
  """
  @repos Application.compile_env(:bagheera, :ecto_repos, [])

  def migrate do
    start_services()

    run_migrations()

    stop_services()
  end

  def rollback(repo, version) do
    start_services()

    Ecto.Migrator.with_repo(repo, fn repo -> Ecto.Migrator.run(repo, :down, to: version) end)

    stop_services()
  end

  defp run_migrations do
    Enum.each(@repos, &run_migrations_for/1)
  end

  defp run_migrations_for(repo) do
    Ecto.Migrator.with_repo(repo, fn repo -> Ecto.Migrator.run(repo, :up, all: true) end)
  end

  defp start_services do
    Application.load(:bagheera)
  end

  defp stop_services do
    Application.stop(:bagheera)
  end
end
