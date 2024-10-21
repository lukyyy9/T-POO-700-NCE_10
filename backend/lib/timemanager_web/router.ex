defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    # Users
    get "/workingTime/:user_id/:id", WorkingTimeController, :get_by_user_id_and_id
    post "/login", UserController, :login
    resources "/users", UserController, except: [:new, :edit]

    # WorkingTime
    post "/workingTime/:user_id", WorkingTimeController, :create
    get "/workingTime/:user_id", WorkingTimeController, :get_by_user_id
    resources "/workingTime", WorkingTimeController, except: [:new, :edit]

    # Clocks
    get "/clocks/:user_id", ClockController, :get_by_user_id
    post "/clocks/:user_id", ClockController, :create
    #resources "/clocks", ClockController, except: [:new, :edit, :create, :show, :update, :delete, :index]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
