class Controller
  def initialize (player)
    @player = player
    @dealer = Dealer.new
    @deck_cards = DeckCards.new
  end

  def distribution_cards
    [@player, @dealer].each do |user|
      user.distribution_cards(@deck_cards.distribution_cards)
      show_cards(user)
    end
  end

  def banks_zero?
    @player.bank.zero? || @dealer.bank.zero?
  end

  def player_miss?
    @player.miss?
  end

  def player_more?
    @player.more?
  end

  def more_card
    @player.more_card(@deck_cards.more_card)
    @dealer.actions(@deck_cards.more_card)
    @dealer.more? ? [@player, @dealer].each { |user| show_cards(user) } : open_cards
  end

  def skip_move
    @player.skip_move
    @dealer.actions(@deck_cards.more_card)
    [@player, @dealer].each { |user| show_cards(user) }
  end

  def open_cards
    [@player, @dealer].each { |user| show_cards(user, false) }
    if @player.points <= 21 && (@player.points > @dealer.points || @dealer.points > 21)
      game_win
    elsif @player.points ==  @dealer.points || (@player.points > 21 && @dealer.points > 21)
      game_draw
    else
      game_lose
    end
  end

  def reset_banks
    [@player, @dealer].each { |user| user.bank = 100 }
  end

  private

  def show_cards(user, closed = true)
    show_card = ''
    user.cards.each { |card| show_card += card.view}
    if user.is_a?(Dealer) && closed
      user.cards.size == 3 ? puts('🂠 🂠 🂠') : puts('🂠 🂠')
    else
      puts show_card
    end
    puts "Количество очков #{user.points}" unless closed
    puts [user.name, '']
  end

  def game_win
    puts ['Вы победили!!!', '']
    reset_values
    @player.bank += @player.rate * 2
    puts ["Ваш банк: #{@player.bank}$","Банк дилера: #{@dealer.bank}$", '']
    distribution_cards unless banks_zero?
  end

  def game_draw
    puts ['Ничья.', '']
    reset_values
    @player.bank += @player.rate
    @dealer.bank += @dealer.rate
    puts ["Ваш банк: #{@player.bank}$","Банк дилера: #{@dealer.bank}$", '']
    distribution_cards unless banks_zero?
  end

  def game_lose
    puts ['Вы проиграли.', '']
    reset_values
    @dealer.bank += @dealer.rate * 2
    puts ["Ваш банк: #{@player.bank}$","Банк дилера: #{@dealer.bank}$", '']
    distribution_cards unless banks_zero?
  end

  def reset_values
    [@player, @dealer].each{ |user| user.reset_values}
    @deck_cards.shuffle_deck
  end
end
