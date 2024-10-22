defmodule YourAppWeb.Plugs.EnsureAdminPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias YourAppWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    # Assuming you have a `current_user` assigned in your connection
    case conn.assigns[:current_user] do
      %YourApp.UserContext.User{role: 3} ->  # Role 3 is admin
        conn
      _ ->
        conn
        |> put_flash(:error, "Access denied")
        |> redirect(to: Routes.page_path(conn, :index))  # Redirect to an appropriate page
        |> halt()
    end
  end
end
