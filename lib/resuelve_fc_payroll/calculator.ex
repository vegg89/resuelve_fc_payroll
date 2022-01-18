defmodule ResuelveFCPayroll.Calculator do
  @minimum_goals %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  def calculate_payroll(%{players: []}), do: %{players: []}

  def calculate_payroll(%{players: players}) do
    team_reach = get_team_reach(players)
    %{players: calculate_players_payroll(players, team_reach)}
  end

  defp get_team_reach(players) do
    {team_goals, team_minimun} =
      Enum.reduce(players, {0, 0}, fn player, {total_acc, minimum_acc} ->
        {total_acc + player.goals, minimum_acc + @minimum_goals[player.level]}
      end)

    reach = Decimal.div(team_goals, team_minimun)
    if Decimal.compare(reach, 1) == :lt, do: reach, else: Decimal.new(1)
  end

  defp get_personal_reach(player) do
    reach = Decimal.div(player.goals, @minimum_goals[player.level])
    if Decimal.compare(reach, 1) == :lt, do: reach, else: Decimal.new(1)
  end

  defp calculate_players_payroll(players, team_reach) do
    Enum.map(players, fn player ->
      personal_reach = get_personal_reach(player)

      total_reach =
        personal_reach
        |> Decimal.add(team_reach)
        |> Decimal.div(2)

      total_bonus = Decimal.mult(player.bonus, total_reach)
      Map.put(player, :total_salary, Decimal.add(player.salary, total_bonus))
    end)
  end
end
