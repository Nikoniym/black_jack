class UserInterface

  def new_game
    begin
      puts 'Как вас зовут?'
      name = gets.chomp
      @player = User.new(name)
    rescue RuntimeError => e
      puts e.message
      retry
    end
    @dealer = Dealer.new
    @deck_cards = DeckCards.new
    start_game
  end

  private

  def start_game
    [@player, @dealer].each{ |user| user.distribution_cards(@deck_cards.distribution_cards) }
    gameplay
  end

  def gameplay
    loop do
      break if  @player.bank.zero? || @dealer.bank.zero?
      input_user
      game_actions
    end
    @player.bank.zero? ? (puts 'Вы банкрот :(') : (puts 'Дилер банкрот. Вы чемпион!!!')
    restart_game
  end

  def game_actions
    if @result == 1 && @player.more
      @player.more_card(@deck_cards.more_card)
      dealer_actions
    elsif  @result == 2 && @player.miss
      @player.skip_move
      dealer_actions
    elsif @result == 3
      open_cards
    else
      puts ['Ошбика ввода!!!', '']
    end
  end

  def input_user
    puts 'Введите:'
    puts '1 - Добавить карту' if @player.more
    puts '2 - Пропустить' if @player.miss
    puts '3 - Открыть карты'
    @result = gets.chomp.to_i
  end

  def open_cards
    [@player, @dealer].each { |user| user.open_cards }
    if @player.points <= 21 && (@player.points > @dealer.points || @dealer.points > 21)
      game_win
    elsif @player.points ==  @dealer.points || (@player.points > 21 && @dealer.points > 21)
      game_draw
    else
      game_lose
    end
  end

  def game_win
    puts ['Вы победили!!!', '']
    reset_values
    @player.bank += @player.rate * 2
    puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}", '']
    start_game unless @player.bank.zero? || @dealer.bank.zero?
  end

  def game_draw
    puts ['Ничья.', '']
    reset_values
    @player.bank += @player.rate
    @dealer.bank += @dealer.rate
    puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}", '']
    start_game unless @player.bank.zero? || @dealer.bank.zero?
  end

  def game_lose
    puts ['Вы проиграли.', '']
    reset_values
    @dealer.bank += @dealer.rate * 2
    puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}", '']
    start_game unless @player.bank.zero? || @dealer.bank.zero?
  end

  def reset_values
    [@player, @dealer].each{ |user| user.reset_values}
    @deck_cards.shuffle_deck
  end

  def restart_game
    puts ['Введите:', '1 - Играть еще раз', '2 - Выход']
    result = gets.chomp.to_i
    if result == 1
      [@player, @dealer].each { |user| user.bank = 100 }
      start_game
    elsif result == 2
      exit
    else
      puts 'Ошибка ввода!!!'
      restart_game
    end
  end

  def dealer_actions
    if @dealer.points >= 17
      @dealer.skip_move
    else
      @dealer.more_card(@deck_cards.more_card)
      open_cards unless @player.more
    end
  end
end
