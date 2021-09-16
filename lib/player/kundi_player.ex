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
      rand > player1.skill / (player2.skill + player1.skill ) ->
        { :win_2, -player2.skill, 0 }
      true ->
        { :win_1, 0, -player1.skill }
    end
  end
  
  def is_alive(player) do
    player.life > 0
  end
  
  def default(name, type) do
    icon = case type do
      :warior -> Enum.random(["/static/img/warior1.png","/static/img/warior2.png", "/static/img/warior3.png"])
      :monster -> Enum.random(["/static/img/monster1.png","/static/img/monster3.png", "/static/img/monster3.png"])
    end
    init(name, type, 10, icon)
  end
  
end
