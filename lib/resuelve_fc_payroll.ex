defmodule ResuelveFCPayroll do
  @moduledoc """
  Documentation for `ResuelveFCPayroll`.
  """

  require Logger

  def main(args \\ []) do
    with {:ok, payroll_data} <- parse_args(args) do
      calculate_total_payroll(payroll_data)
    else
      {:error, :no_arg} ->
        Logger.error("No argument supplied.")

      {:error, %Jason.DecodeError{}} ->
        Logger.error("Unable to read JSON data.")

      {:error, msg} ->
        Logger.error("Unexpected error: #{inspect(msg)}.")
    end
  end

  defp parse_args([]), do: {:error, :no_arg}

  defp parse_args([arg]) do
    Jason.decode(arg)
  end

  defp calculate_total_payroll(_payroll_data) do
    # TODO: Implement
    {:ok, true}
  end
end
