class Player
  attr_reader :name, :rate, :cards
  attr_accessor :bank, :points

  def initialize(name)
    @name = name
    validate!
    @bank = 100
    @rate = 10
    @more = true
    @miss = true
  end

  def distribution_cards(cards)
    @points = cards.first.value + cards.last.value
    calculation_ace(cards)
    @bank = @bank - @rate
    @cards = cards
  end

  def more_card(card)
    if @more
      @points += card.value
      @cards << card
      calculation_ace(@cards)
      @more = false
    end
  end

  def skip_move
    @miss = false
  end

  def reset_values
    @more = true
    @miss = true
    @points = 0
  end

  def miss?
    @miss
  end

  def more?
    @more
  end

  protected

  def calculation_ace(cards)
    cards.each do |card|
      @points -= 10 if card.value == 11 && @points > 21
    end
  end

  def validate!
    raise 'Имя не может быть пустым!!!' if @name.empty?
  end
end
