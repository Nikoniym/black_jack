class Dealer < Player
  def initialize(name = 'Дилер')
    super
  end

  def actions(card)
    if @points >= 17
      skip_move
    else
      more_card(card)
    end
  end
end
