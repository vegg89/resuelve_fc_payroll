defmodule ResuelveFCPayroll.CalculatorTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  alias ResuelveFCPayroll.Calculator
  # doctest ResuelveFCPayroll.Calculator

  describe "ResuelveFCPayroll.calculate_payroll/1" do
    setup :player

    test "return 100% bonus when minimum goals are achieved", %{player: player} do
      result = Calculator.calculate_payroll(%{players: [player]})
      assert Decimal.eq?(hd(result.players).total_salary, Decimal.new(60000))
    end

    test "return 100% bonus when minimum goals are surpassed", %{player: player} do
      input = %{player | goals: 6}
      result = Calculator.calculate_payroll(%{players: [input]})
      assert Decimal.eq?(hd(result.players).total_salary, Decimal.new(60000))
    end

    test "return according bonus when minimum goals are not achieved", %{player: player} do
      input = %{player | goals: 4}
      result = Calculator.calculate_payroll(%{players: [input]})
      assert Decimal.eq?(hd(result.players).total_salary, Decimal.new(58000))
    end

    test "return according bonus when minimum goals are not achieved by team", %{player: player} do
      player1 = %{player | goals: 6, level: "A"}
      player2 = %{player | goals: 7, level: "B", name: "Pedro"}
      player3 = %{player | goals: 16, level: "C", name: "Martin"}
      player4 = %{player | goals: 19, level: "Cuauh", name: "Luis"}

      result =
        %{players: [player1, player2, player3, player4]}
        |> Calculator.calculate_payroll()
        |> Map.get(:players)
        |> Enum.find(&(&1.name == "Luis"))

      assert Decimal.eq?(result.total_salary, Decimal.new(59550))
    end
  end

  defp player(_context) do
    player = %{
      name: "Juan",
      goals: 5,
      salary: 50000,
      bonus: 10000,
      level: "A"
    }

    {:ok, player: player}
  end
end
