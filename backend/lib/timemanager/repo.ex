defmodule Timemanager.Repo do
  use Ecto.Repo,
    otp_app: :timemanager,
    adapter: Ecto.Adapters.Postgres

  # Fonction qui lit et parse le fichier .env
  defp load_env_file do
    # Spécifier le chemin de ton fichier .env
    env_file_path = Path.expand("../../.env", __DIR__)

    # Vérifie si le fichier existe avant de le lire
    if File.exists?(env_file_path) do
      # Lire le fichier ligne par ligne et le parser
      env_file_path
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce(%{}, fn line, acc ->
        case String.split(line, "=") do
          [key, value] -> Map.put(acc, key, String.trim(value))
          _ -> acc
        end
      end)
    else
      %{}  # Retourne une map vide si le fichier n'existe pas
    end
  end

  def init(_, config) do
    env_vars = load_env_file()

    #log the env vars
    IO.inspect(env_vars)

    # Remplacer les valeurs des variables d'environnement si elles sont nulles
    config = config
    |> Keyword.put(:username, System.get_env("PGUSER") || env_vars["PGUSER"])
    |> Keyword.put(:password, System.get_env("PGPASSWORD") || env_vars["PGPASSWORD"])
    |> Keyword.put(:database, System.get_env("PGDATABASE") || env_vars["PGDATABASE"])
    |> Keyword.put(:hostname, System.get_env("PGHOST") || env_vars["PGHOST"])
    |> Keyword.put(:port, (System.get_env("PGPORT") || env_vars["PGPORT"]) |> String.to_integer)

    {:ok, config}
  end
end
