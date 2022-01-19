defmodule ResuelveFCPayroll do
  @moduledoc """
  Documentation for `ResuelveFCPayroll`.
  """

  alias ResuelveFCPayroll.Calculator
  require Logger

  @spec main([] | list(String.t())) ::
          String.t() | {:error, :no_arg | :bad_structure | Jason.DecodeError.t()}
  def main(args \\ []) do
    with {:ok, payroll_data} <- parse_args(args),
         {:ok, calculated_json} <- Calculator.calculate_payroll(payroll_data) do
      result = Jason.encode!(calculated_json)

      Logger.info(result)
      result
    else
      {:error, :no_arg} ->
        Logger.error("No argument supplied.")
        {:error, :no_arg}

      {:error, decode_error = %Jason.DecodeError{}} ->
        Logger.error("Unable to read JSON data.")
        {:error, decode_error}

      {:error, :bad_structure} ->
        Logger.error("Bad JSON structure.")
        {:error, :bad_structure}
    end
  end

  defp parse_args([]), do: {:error, :no_arg}

  defp parse_args([arg]) do
    Jason.decode(arg)
  end
end
