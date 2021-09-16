defmodule KundiGame do
  require Logger
  @moduledoc false

  defstruct [:ets, :width, :height]

  def init(width, height) do
    ets = :ets.new(:ets, [ :set, :public, { :read_concurrency, true }, { :write_concurrency, true }])
    game = %KundiGame{
      ets: ets,
      width: width,
      height: height
    }
    walls(game, 10)
    game
  end

  def get(game, x, y) do
    case :ets.lookup(game.ets, { x, y }) do
      [{ _, el }] -> el
      [] -> :none
    end
  end
  
  def put(game, x, y, :none) do
    case check_borders(game, x, y) do
      false -> :ok
      true ->
        :ets.delete(game.ets, { x, y })
        :ok
    end
  end
  
  def put(game, x, y, what) do
    case check_borders(game, x, y) do
      false -> { :error, :occupied }
      true ->
        case :ets.insert_new(game.ets, {{ x, y }, what}) do
          true -> :ok
          false -> { :error, :occupied }
        end
    end
  end

  def at_near(game, x, y) do
    List.foldl([{x-1, y-1}, {x-1, y}, { x-1, y+1 }, {x, y-1 }, { x, y+1 }, { x+1, y-1 }, {x+1, y }, {x+1, y+1 }], [], fn {x0, y0}, acc ->
      el = get(game, x0, y0)
      case el do
        :none -> acc;
        _ -> [ {{x0, y0}, el} | acc ]
      end
    end)
  end
  
  def can_move(game, x, y) do
    cond do
      x < 1 -> false
      y < 1 -> false
      x > game.width -> false
      y > game.height -> false
      true ->
        get(game, x, y ) == :none
    end
  end
  
  def is_empty(game, x, y) do
    not :ets.member(game.ets, { x, y })
  end
  
  def rand_position(game) do
    x = :rand.uniform(game.width)
    y = :rand.uniform(game.height)
    case is_empty(game, x, y) do
      true -> { x, y }
      false ->
        rand_position(game)
    end
  end
  
  def get_board(game) do
    :ets.foldl(fn(item, acc) -> [ item | acc ] end, [], game.ets)
  end
  
  def walls(game, count) do
    Enum.each(1..count, fn _ ->
      { x, y } = rand_position(game)
      put(game, x, y, :wall)
    end)
  end
  
  ## PRIVATE
  
  defp check_borders(game, x, y) do
    cond do
      x < 1 -> false
      y < 1 -> false
      x > game.width -> false
      y > game.height -> false
      true -> true
    end
  end
  
end
