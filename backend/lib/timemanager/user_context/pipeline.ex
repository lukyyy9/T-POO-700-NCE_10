defmodule Timemanager.UserContext.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :timemanager,
    error_handler: Timemanager.UserContext.ErrorHandler,
    module: Timemanager.UserContext.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
