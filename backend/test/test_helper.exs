ExUnit.start()
Application.ensure_all_started(:timemanager)
Mox.defmock(Timemanager.ClockContextMock, for: Timemanager.ClockContextBehaviour)
Application.put_env(:timemanager, :clock_context, Timemanager.ClockContextMock)
Mox.defmock(Timemanager.UserContextMock, for: Timemanager.UserContextBehaviour)
#Mox.start()
Ecto.Adapters.SQL.Sandbox.mode(Timemanager.Repo, :manual)
