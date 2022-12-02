defmodule Adventofcode2022.Day02.RockPaperScissorsTest do
  use ExUnit.Case 

  alias Adventofcode2022.Day02.RockPaperScissors

  test "Strategy 1 - returns my total score (from input.txt)" do
    input = File.read!(Path.join(__DIR__, "./input.txt")) 

    {_opponent_score, my_score} = RockPaperScissors.get_total_scores(input, :one)

    assert my_score == 10404
  end

  test "Strategy 1 - returns my total score" do
    {_opponent_score, my_score} =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.get_total_scores(:one)

    assert my_score == 15
  end

  test "Strategy 1 - returns a list of finished rounds" do
    result =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.play(:one)

    assert result == [
      {{:A, :Y}, {:ROCK, :PAPER}, {{1, 0}, {2, 6}}},
      {{:B, :X}, {:PAPER, :ROCK}, {{2, 6}, {1, 0}}},
      {{:C, :Z}, {:SCISSORS, :SCISSORS}, {{3, 3}, {3, 3}}}
    ]
  end

  test "Strategy 2 - returns my total score (from input.txt)" do
    input = File.read!(Path.join(__DIR__, "./input.txt")) 

    {_opponent_score, my_score} = RockPaperScissors.get_total_scores(input, :two)

    assert my_score == 10334
  end

  test "Strategy 2 - returns my total score" do
    {_opponent_score, my_score} =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.get_total_scores(:two)

    assert my_score == 12
  end

  @tag :pending
  test "Strategy 2 - returns a list of finished rounds" do
    result =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.play(:two)

    assert result == [
      {{:A, :Y}, {:ROCK, :ROCK}, {{1, 3}, {1, 3}}}, 
      {{:B, :X}, {:PAPER, :ROCK}, {{2, 6}, {1, 0}}},
      {{:C, :Z}, {:SCISSORS, :ROCK}, {{3, 0}, {1, 6}}}]
  end
end
