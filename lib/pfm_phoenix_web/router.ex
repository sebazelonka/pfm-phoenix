defmodule PfmPhoenixWeb.Router do
  use PfmPhoenixWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PfmPhoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug PfmPhoenixWeb.EnsureRolePlug, :admin
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/" do
    pipe_through [:browser, :admin]

    get "/users", PfmPhoenixWeb.UserController, :index
  end

  scope "/", PfmPhoenixWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/expenses", ExpenseController
    resources "/categories", CategoryController
  end

  scope "/admin", PfmPhoenixWeb do
    pipe_through [:browser, :admin]

    # ...
  end

  # Other scopes may use custom stacks.
  # scope "/api", PfmPhoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pfm_phoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PfmPhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
