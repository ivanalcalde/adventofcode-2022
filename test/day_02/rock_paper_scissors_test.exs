defmodule Adventofcode2022.Day02.RockPaperScissorsTest do
  use ExUnit.Case 

  alias Adventofcode2022.Day02.RockPaperScissors

  test "returns my total score (from input.txt)" do
    input = File.read!(Path.join(__DIR__, "./input.txt")) 

    {_opponent_score, my_score} = RockPaperScissors.get_total_scores(input)

    assert my_score == 10404
  end

  test "returns my total score" do
    {_opponent_score, my_score} =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.get_total_scores()

    assert my_score == 15
  end

  test "returns a list of finished rounds" do
    result =
      """
      A Y
      B X
      C Z
      """
      |> RockPaperScissors.play()

    assert result == [
      {
        {:A, :Y},
        {:ROCK, :PAPER},
        {{1, 0}, {2, 6}}
      },
      {
        {:B, :X},
        {:PAPER, :ROCK},
        {{2, 6}, {1, 0}}
      },
      {
        {:C, :Z},
        {:SCISSORS, :SCISSORS},
        {{3, 3}, {3, 3}}
      }
    ]
  end
end
