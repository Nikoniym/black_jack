class User < Player
  def distribution_cards(cards)
    show_card(cards)
    super
  end

  def more_card(card)
    super
    show_card(@cards)
  end
end
