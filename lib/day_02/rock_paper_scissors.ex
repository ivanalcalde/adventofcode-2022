defmodule Adventofcode2022.Day02.RockPaperScissors do
  @type strategy           :: :one | :two
  @type move               :: :ROCK | :PAPER | :SCISSORS
  @type move_encrypted     :: :A | :B | :C | :X | :Y | :Z
  @type points_from_move   :: 1 | 2 | 3
  @type points_from_battle :: 0 | 3 | 6
  @type round              :: {move, move}
  @type round_encrypted    :: {move_encrypted, move_encrypted}
  @type player_points      :: {points_from_move, points_from_battle}
  @type round_points       :: {player_points, player_points}
  @type finished_round     :: {round_encrypted, round, round_points}

  @spec get_total_scores(String.t, strategy) :: {integer, integer}
  def get_total_scores(input, strategy) do
    input
    |> play(strategy)
    |> Enum.reduce({0, 0}, fn {_, _, {opponent_points, my_points}}, {opponent_acc, my_acc} -> 
      {opponent_points_from_move, opponent_points_from_battle} = opponent_points 
      {my_points_from_move, my_points_from_battle} = my_points 

      {
        opponent_acc + opponent_points_from_move + opponent_points_from_battle,
        my_acc       + my_points_from_move       + my_points_from_battle
      }
    end)
  end

  @spec play(String.t, strategy) :: list(finished_round)
  def play(input, strategy) do
    input
    |> to_input_rounds()
    |> Enum.map(&to_round/1)
    |> Enum.map(&play_round(&1, strategy))
  end

  @spec play_round(round_encrypted, strategy) :: finished_round
  defp play_round(round_encrypted, strategy) do
    round = decrypt_round(round_encrypted, strategy)
    round_points = calculate_round_points(round)

    {
      round_encrypted,
      round,
      round_points
    }
  end

  @spec to_input_rounds(String.t) :: list(String.t)
  defp to_input_rounds(input) do
    String.split(input, "\n", trim: true)
  end

  @spec to_round(String.t) :: round_encrypted
  defp to_round(input_round) do
    input_round
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
  end

  @spec calculate_round_points(round) :: round_points
  defp calculate_round_points(round) do
    {opponent_points_from_move, my_points_from_move} = points_from_moves(round)
    {opponent_points_from_battle, my_points_from_battle} = points_from_battle(round)

    opponent_points = {opponent_points_from_move, opponent_points_from_battle}
    my_points = {my_points_from_move, my_points_from_battle}

    {opponent_points, my_points}
  end

  @spec points_from_moves(round) :: {points_from_move, points_from_move}

  @move_points %{
    ROCK: 1,
    PAPER: 2,
    SCISSORS: 3
  }
  defp points_from_moves({opponent_move, my_move}) do
    {
      Map.get(@move_points, opponent_move, 0),
      Map.get(@move_points, my_move, 0)
    }
  end

  @spec points_from_battle(round) :: {points_from_battle, points_from_battle}

  @win 6
  @loss 0
  @draw 3
  def points_from_battle(round) do
    case round do
      {:ROCK, :PAPER}     -> {@loss, @win}
      {:ROCK, :SCISSORS}  -> {@win,  @loss}
      {:PAPER, :ROCK}     -> {@win,  @loss}
      {:PAPER, :SCISSORS} -> {@loss, @win}
      {:SCISSORS, :ROCK}  -> {@loss, @win}
      {:SCISSORS, :PAPER} -> {@win,  @loss}
      {_, _}              -> {@draw, @draw}
    end
  end

  @spec decrypt_round(round_encrypted, strategy) :: round
  defp decrypt_round({opponent_move_encrypted, my_move_encrypted}, strategy) do
    opponent_move = decrypt_move(opponent_move_encrypted)
    my_move = if strategy == :one do
      decrypt_move(my_move_encrypted)
    else
      decrypt_move_by_outcome(my_move_encrypted, opponent_move)
    end

    { opponent_move, my_move }
  end

  @spec decrypt_move(move_encrypted) :: move

  @moves_decryption_map %{
    A: :ROCK,
    B: :PAPER,
    C: :SCISSORS,
    X: :ROCK,
    Y: :PAPER,
    Z: :SCISSORS
  }
  def decrypt_move(move_encrypted) do
    Map.get(@moves_decryption_map, move_encrypted) 
  end

  @spec decrypt_move_by_outcome(move_encrypted, move) :: move

  @outcome_encription_map %{
    X: :loss,
    Y: :draw,
    Z: :win
  }
  def decrypt_move_by_outcome(move_encrypted, move) do
    outcome = Map.get(@outcome_encription_map, move_encrypted)

    case outcome do
      :draw -> move
      :loss -> case move do
        :ROCK     -> :SCISSORS
        :PAPER    -> :ROCK
        :SCISSORS -> :PAPER 
      end
      :win -> case move do
        :ROCK     -> :PAPER
        :PAPER    -> :SCISSORS
        :SCISSORS -> :ROCK
      end
    end
  end
end
