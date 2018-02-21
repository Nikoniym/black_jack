class DeckCards
  def initialize
    @cards = %w(🂡 🂱 🃁 🃑 🂢 🂲 🃂 🃒 🂣 🂳 🃃 🃓 🂤 🂴 🃄 🃔
                🂥 🂵 🃅 🃕 🂦 🂶 🃆 🃖 🂧 🂷 🃇 🃗 🂨 🂸 🃈 🃘
                🂩 🂹 🃉 🃙 🂪 🂺 🃊 🃚 🂫 🂻 🃋 🃛 🂭 🂽 🃍 🃝
                🂮 🂾 🃎 🃞)
    @position = 0
    create_deck
    @deck = @deck.shuffle
  end

  def create_deck
    @deck = []
    @cards.each_slice(4).with_index(1) do |cards, index|
      if index == 1
        value = 11
      elsif index >=10
        value = 10
      else
        value = index
      end

      cards.each { |card| @deck << Card.new(card + ' ', value) }
    end
  end

  def distribution_cards
    cards = @deck[@position..@position+1]
    @position += 2
    cards
  end

  def more_card
    card = @deck[@position]
    @position += 1
    card
  end

  def shuffle_deck
    @deck = @deck.shuffle
    @position = 0
  end
end
