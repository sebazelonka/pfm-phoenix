defmodule PfmPhoenixWeb.Router do
  use PfmPhoenixWeb, :router

  import PfmPhoenixWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PfmPhoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope("/", PfmPhoenixWeb) do
    pipe_through [:browser, :require_authenticated_user]

    # dashboard
    live "/dashboard", DashboardLive.Index, :index
    live "/dashboard/new", DashboardLive.Index, :new
    live "/dashboard/:id/edit", DashboardLive.Index, :edit

    # transactions
    live "/transactions", TransactionLive.Index, :index
    live "/transactions/new", TransactionLive.Index, :new
    live "/transactions/:id/edit", TransactionLive.Index, :edit

    live "/transactions/:id", TransactionLive.Show, :show
    live "/transactions/:id/show/edit", TransactionLive.Show, :edit

    # budgets
    live "/budgets", BudgetLive.Index, :index
    live "/budgets/new", BudgetLive.Index, :new
    live "/budgets/:id/edit", BudgetLive.Index, :edit

    live "/budgets/:id", BudgetLive.Show, :show
    live "/budgets/:id/show/edit", BudgetLive.Show, :edit

    # credit cards
    live "/credit_cards", CreditCardLive.Index, :index
    live "/credit_cards/new", CreditCardLive.Index, :new
    live "/credit_cards/:id/edit", CreditCardLive.Index, :edit

    live "/credit_cards/:id", CreditCardLive.Show, :show
    live "/credit_cards/:id/show/edit", CreditCardLive.Show, :edit

    # forecast
    live "/forecast", ForecastLive.Index, :index
  end

  # app admin
  scope "/", PfmPhoenixWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/users", UsersLive.Index, :index
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

  ## Authentication routes

  scope "/", PfmPhoenixWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PfmPhoenixWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/", HomeLive.Index, :index
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PfmPhoenixWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PfmPhoenixWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", PfmPhoenixWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PfmPhoenixWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
