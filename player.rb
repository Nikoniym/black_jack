class Player
  attr_reader :name, :more, :miss, :rate
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
    puts [@name, '']
    @points = cards[0][1] + cards[1][1]
    calculation_ace(cards)
    @bank = @bank - @rate
    @cards = cards
  end

  def more_card(card)
    if @more
      @points += card[1]
      @cards << card
      calculation_ace(@cards)
      @more = false
    end
  end

  def skip_move
    @miss = false
  end

  def open_cards
    puts @name
    show_card(@cards)
    puts ["Количество очков #{@points}", '']
  end

  def reset_values
    @more = true
    @miss = true
    @points = 0
  end

  protected

  def show_card(cards)
    show_card = ''
    cards.each { |card| show_card += card[0]}
    puts show_card
  end

  def calculation_ace(cards)
    cards.each do |arg|
      @points -= 10 if arg[1] == 11 && @points > 21
    end
  end

  def validate!
    raise 'Имя не может быть пустым!!!' if @name.empty?
  end
end
