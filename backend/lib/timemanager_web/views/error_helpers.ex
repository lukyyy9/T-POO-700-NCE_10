defmodule TimemanagerWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use PhoenixHTMLHelpers

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # If you want to use gettext for translations, uncomment the following lines
    # and make sure you have the `gettext` dependency and configuration set up.
    #
    # if count = opts[:count} do
    #   Gettext.dngettext(TimemanagerWeb.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(TimemanagerWeb.Gettext, "errors", msg, opts)
    # end

    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error), class: "help-block")
    end)
  end
end
