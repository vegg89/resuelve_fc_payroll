defmodule ResuelveFCPayroll.Calculator do
  require Logger

  @minimum_goals %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  @spec calculate_payroll(map()) :: {:error, :bad_structure} | {:ok, map()}
  def calculate_payroll(%{"teams" => teams}) do
    {:ok, %{teams: calculate_teams_payroll(teams)}}
  end

  def calculate_payroll(team = %{"players" => players}) do
    minimum_goals = team["minimum_goals"] || @minimum_goals
    team_reach = get_team_reach(players, minimum_goals)
    {:ok, %{players: calculate_players_payroll(players, minimum_goals, team_reach)}}
  end

  def calculate_payroll(_), do: {:error, :bad_structure}

  defp get_team_reach(players, minimum_goals) do
    {team_goals, team_minimun} =
      Enum.reduce(players, {0, 0}, fn player, {total_acc, minimum_acc} ->
        minimum = minimum_goals[player["level"]] || 5
        {total_acc + player["goals"], minimum_acc + minimum}
      end)

    reach = Decimal.div(team_goals, team_minimun)
    if Decimal.compare(reach, 1) == :lt, do: reach, else: Decimal.new(1)
  end

  defp get_personal_reach(player, minimum_goals) do
    minimum = minimum_goals[player["level"]] || 5
    reach = Decimal.div(player["goals"], minimum)
    if Decimal.compare(reach, 1) == :lt, do: reach, else: Decimal.new(1)
  end

  defp calculate_teams_payroll(teams) do
    Enum.reduce(teams, [], fn team, team_acc ->
      case calculate_payroll(team) do
        {:ok, calculated_team} ->
          [calculated_team | team_acc]

        {:error, :bad_structure} ->
          Logger.warn("Team does not have the expected format, skipping team")
          team_acc
      end
    end)
  end

  defp calculate_players_payroll(players, minimum_goals, team_reach) do
    Enum.map(players, fn player ->
      personal_reach = get_personal_reach(player, minimum_goals)

      total_reach =
        personal_reach
        |> Decimal.add(team_reach)
        |> Decimal.div(2)

      total_bonus = Decimal.mult(player["bonus"], total_reach)
      Map.put(player, "total_salary", Decimal.add(player["salary"], total_bonus))
    end)
  end
end
