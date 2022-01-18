defmodule ResuelveFCPayrollTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  # doctest ResuelveFCPayroll

  describe "ResuelveFCPayroll.main/1" do
    setup :players

    test "return payroll data", %{players: players} do
      input = Jason.encode!(players)

      assert "{\"players\":[{\"bonus\":10000,\"goals\":19,\"level\":\"Cuauh\",\"salary\":50000,\"total_salary\":\"59500.00\"}]}" ==
               ResuelveFCPayroll.main([input])
    end

    test "return error if no arguments are supplied" do
      {_result, log} = with_log(&ResuelveFCPayroll.main/0)
      assert log =~ "No argument supplied."
    end

    test "return error if --json argument can't be parsed" do
      {_result, log} = with_log(fn -> ResuelveFCPayroll.main(["malformed_json"]) end)
      assert log =~ "Unable to read JSON data."
    end
  end

  defp players(_context) do
    players = %{
      players: [
        %{
          goals: 19,
          salary: 50000,
          bonus: 10000,
          level: "Cuauh"
        }
      ]
    }

    {:ok, players: players}
  end
end
