defmodule ResuelveFCPayroll.CalculatorTest do
  use ExUnit.Case
  alias ResuelveFCPayroll.Calculator
  # doctest ResuelveFCPayroll.Calculator

  describe "ResuelveFCPayroll.calculate_payroll/1" do
    setup [:player, :team]

    test "return 100% bonus when minimum goals are achieved", %{player: player} do
      {:ok, result} = Calculator.calculate_payroll(%{"players" => [player]})
      assert Decimal.eq?(hd(result.players)["total_salary"], Decimal.new(60000))
    end

    test "return 100% bonus when minimum goals are surpassed", %{player: player} do
      input = %{player | "goals" => 6}
      {:ok, result} = Calculator.calculate_payroll(%{"players" => [input]})
      assert Decimal.eq?(hd(result.players)["total_salary"], Decimal.new(60000))
    end

    test "return according bonus when minimum goals are not achieved", %{player: player} do
      input = %{player | "goals" => 4}
      {:ok, result} = Calculator.calculate_payroll(%{"players" => [input]})
      assert Decimal.eq?(hd(result.players)["total_salary"], Decimal.new(58000))
    end

    test "return according bonus when minimum goals are not achieved by team", %{team: team} do
      result =
        %{"players" => team}
        |> Calculator.calculate_payroll()
        |> elem(1)
        |> Map.get(:players)
        |> Enum.find(&(&1["name"] == "Luis"))

      assert Decimal.eq?(result["total_salary"], Decimal.new(59550))
    end

    test "calculate total salary for mutiple teams", %{team: team} do
      result_teams =
        %{"teams" => [%{"players" => team}, %{"players" => team}]}
        |> Calculator.calculate_payroll()
        |> elem(1)
        |> Map.get(:teams)

      assert length(result_teams) == 2

      Enum.each(result_teams, fn %{players: players} ->
        player = Enum.find(players, &(&1["name"] == "Luis"))
        assert Decimal.eq?(player["total_salary"], Decimal.new(59550))
      end)
    end

    test "calculate total salary for mutiple teams with custom rules", %{team: team} do
      minimum_rules = %{"A" => 20, "B" => 20, "C" => 30, "Cuauh" => 50}

      result_teams =
        %{"teams" => [%{"players" => team, "minimum_goals" => minimum_rules}]}
        |> Calculator.calculate_payroll()
        |> elem(1)
        |> Map.get(:teams)

      Enum.each(result_teams, fn %{players: players} ->
        player = Enum.find(players, &(&1["name"] == "Luis"))
        assert Decimal.eq?(player["total_salary"], Decimal.new(53900))
      end)
    end

    test "skip team that doesn not have the correct format", %{team: team} do
      result_teams =
        %{"teams" => [%{}, %{"players" => team}]}
        |> Calculator.calculate_payroll()
        |> elem(1)
        |> Map.get(:teams)

      assert length(result_teams) == 1
    end
  end

  defp player(_context) do
    player = %{
      "name" => "Juan",
      "goals" => 5,
      "salary" => 50000,
      "bonus" => 10000,
      "level" => "A"
    }

    {:ok, player: player}
  end

  defp team(%{player: player}) do
    player1 = %{player | "goals" => 6, "level" => "A"}
    player2 = %{player | "goals" => 7, "level" => "B", "name" => "Pedro"}
    player3 = %{player | "goals" => 16, "level" => "C", "name" => "Martin"}
    player4 = %{player | "goals" => 19, "level" => "Cuauh", "name" => "Luis"}

    {:ok, team: [player1, player2, player3, player4]}
  end
end
