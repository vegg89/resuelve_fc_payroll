defmodule ResuelveFCPayroll do
  @moduledoc """
  Documentation for `ResuelveFCPayroll`.
  """

  alias ResuelveFCPayroll.Calculator
  require Logger

  def main(args \\ []) do
    with {:ok, payroll_data} <- parse_args(args) do
      result =
        payroll_data
        |> Calculator.calculate_payroll()
        |> Jason.encode!()

      Logger.info(result)
      result
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
    Jason.decode(arg, keys: :atoms)
  end
end
