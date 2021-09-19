defmodule KundiGameTest do
  use ExUnit.Case
  alias KundiGame, as: Game
  doctest KundiGame

  setup do
    game = Game.init(10,10)
    Game.put(game, 1,1, :something)
    { :ok, game: game }
  end
  
  test "get function", %{ :game => game } do
    assert Game.get(game, 1,1) == :something
    assert Game.get(game, 1,2) == :none
  end
  
  test "put function",  %{ :game => game } do
    assert Game.put(game, 1,2, :data1) == :ok
    assert Game.get(game, 1,2) == :data1
    
    assert Game.put(game, 1,1, :data1) == {:error, :occupied}
  end
  
  test "at_near function",  %{ :game => game } do
    assert Game.at_near(game, 2,2) == [{{1,1}, :something}]
  end
  
  test "can_move? function", %{ :game => game } do
    assert Game.can_move?(game, 1,1) == false
    assert Game.can_move?(game, 1,2) == true
  end
  
  test "rand_position function", %{ :game => game } do
    Game.walls(game, 20)
    Enum.each(1..100, fn _ ->
      { x, y } = Game.rand_position(game)
      assert Game.can_move?(game, x, y) == true
    end)
  end
  
  test "get_board function",  %{ :game => game } do
    assert Game.get_board(game) == [{{1,1}, :something}]
  end
end

