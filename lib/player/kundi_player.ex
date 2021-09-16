defmodule KundiPlayer do
  @moduledoc false
  defstruct [:name, :type, :skill, :life, :icon ]
  
  alias KundiPlayer, as: Player

  def init(name, type, skill, icon) do
    %Player{
      name: name,
      type: type,
      skill: skill,
      life: 100,
      icon: icon
    }
  end

  def attack(player1, player2) do
    rand = :rand.uniform()
    cond do
      rand > player1.skill / player2.skill ->
        { :win_2, %Player{ player1 | life: player1.life - player2.skill }, player2 }
      true ->
        { :win_1, player1, %Player{ player2 | life: player2.life - player1.skill } }
    end
  end
  
  def is_alive(player) do
    player.life > 0
  end
  
  def default(name, type) do
    icon = case type do
      :warior -> "/static/img/warior1.png"
      :monster -> "/static/img/monster1.png"
    end
    init(name, type, 1, icon)
  end
  
end
