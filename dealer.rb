class Dealer < Player
  def initialize(name = 'Дилер')
    super
  end

  def distribution_cards(cards)
    puts '🂠 🂠'
    super
  end

  def more_card(card)
    puts '🂠 🂠 🂠'
    super
    puts [@name, '']
  end

  def skip_move
    puts ['Дилер пропустил ход', '']
  end
end
