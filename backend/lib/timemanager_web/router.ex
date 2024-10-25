defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  # Define the API pipeline
  pipeline :api do
    plug :accepts, ["json"]
  end

  # Define the authenticated pipeline using Guardian with a minimal error handler
  pipeline :authenticated do
    plug Guardian.Plug.Pipeline,
      module: Timemanager.UserContext.Guardian,
      error_handler: TimemanagerWeb.BasicAuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    # Public route - no authentication required
    post "/login", UserController, :login

    # Apply the authenticated pipeline only for protected routes
    pipe_through :authenticated

    # Users (protected routes)
    get "/workingTime/:user_id/:id", WorkingTimeController, :get_by_user_id_and_id
    resources "/users", UserController, except: [:new, :edit]

    # WorkingTime
    post "/workingTime/:user_id", WorkingTimeController, :create
    get "/workingTime/:user_id", WorkingTimeController, :get_by_user_id
    resources "/workingTime", WorkingTimeController, except: [:new, :edit]

    # Clocks
    get "/clocks/:user_id", ClockController, :get_by_user_id
    post "/clocks/:user_id", ClockController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development

end
