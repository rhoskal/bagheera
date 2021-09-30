defmodule BagheeraWeb.Router do
  use BagheeraWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() in [:dev, :test] do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BagheeraWeb.Schema
  end

  scope "/graphql", BagheeraWeb do
    pipe_through :api

    get "/health", HealthCheckController, :index
  end

  forward "/graphql", Absinthe.Plug, schema: BagheeraWeb.Schema

  scope "/", BagheeraWeb do
    pipe_through :browser

    get "/:hash", LinkVisitController, :show
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BagheeraWeb.Telemetry
    end
  end
end
