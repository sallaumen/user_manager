defmodule UserManagerWeb.Utils.ErrorMessages do
  @spec get_required_field_err_message(String.t()) :: String.t()
  def get_required_field_err_message(field),
    do: "Invalid parameter. Missing required field `#{field}`."

  @spec get_invalid_type_err_message(String.t(), String.t(), String.t()) :: String.t()
  def get_invalid_type_err_message(value, field_name, string_required_types),
    do:
      "Invalid parameter. Given value `#{value}` for parameter `#{field_name}` is not a valid #{string_required_types}."
end
