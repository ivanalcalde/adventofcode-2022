defmodule Adventofcode2022.Day09.RopeBridgeTest do
  use ExUnit.Case

  alias Adventofcode2022.Day09.RopeBridge

  # @tag :skip
  test "returns the total amount of positions visited by the tail" do
    count =
      """
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
      """
      |> RopeBridge.init([:H, :T])
      |> RopeBridge.run()
      |> List.last()
      |> RopeBridge.count_positions(:T)

    assert count == 13
  end

  # @tag :skip
  test "returns the total amount of positions visited by the tail (input file)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    count =
      input
      |> RopeBridge.init([:H, :T])
      |> RopeBridge.run()
      |> List.last()
      |> RopeBridge.count_positions(:T)

    assert count == 6256
  end

  # @tag :skip
  test "returns the total amount of positions visited by the :9 (input 1)" do
    count =
      """
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
      """
      |> RopeBridge.init([:H, :"1", :"2", :"3", :"4", :"5", :"6", :"7", :"8", :"9"])
      |> RopeBridge.run()
      |> List.last()
      |> RopeBridge.count_positions(:"9")

    assert count == 1
  end

  # @tag :skip
  test "returns the total amount of positions visited by the :9 (input 2)" do
    state =
      """
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
      """
      |> RopeBridge.init([:H, :"1", :"2", :"3", :"4", :"5", :"6", :"7", :"8", :"9"])
      |> RopeBridge.run()
      |> List.last()
    
    # RopeBridge.paint_movements(state, :H)
    # RopeBridge.paint_movements(state, :"1")
    # RopeBridge.paint_movements(state, :"2")
    # RopeBridge.paint_movements(state, :"3")
    # RopeBridge.paint_movements(state, :"4")
    # RopeBridge.paint_movements(state, :"5")
    # RopeBridge.paint_movements(state, :"6")
    # RopeBridge.paint_movements(state, :"7")
    # RopeBridge.paint_movements(state, :"8")
    RopeBridge.paint_movements(state, :"9")

    assert RopeBridge.count_positions(state, :"9") == 36
  end

  # @tag :skip
  test "returns the total amount of positions visited by the :9 (input file)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    state =
      input
      |> RopeBridge.init([:H, :"1", :"2", :"3", :"4", :"5", :"6", :"7", :"8", :"9"])
      |> RopeBridge.run()
      |> List.last()
    
    # RopeBridge.paint_movements(state, :"9")

    assert RopeBridge.count_positions(state, :"9") == 2665
  end
end
