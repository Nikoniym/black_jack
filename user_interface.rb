class UserInterface
  def initialize
    @players = []
  end
  def new_game
    puts 'Как вас зовут?'
    name = gets.chomp
    @player = User.new(name)
    @dealer = Dealer.new
    @deck_cards = DeckCards.new
    start_game
  end

  def start_game
    [@player, @dealer].each{ |player| player.distribution_cards(@deck_cards.distribution_cards) }
    gameplay
  end

  def gameplay
    loop do
      break if  @player.bank.zero? || @dealer.bank.zero?
      puts 'Введите:'
      limit = 1
      if @player.more
        puts '1 - Добавить карту'
      else
        @player.miss ? limit = 2 : limit = 3
      end

      if @player.miss
        puts '2 - Пропустить'
      else
        @player.more ? limit = 2 : limit = 3
      end
      puts '3 - Открыть карты'
      result = gets.chomp.to_i

      puts 'Ошибка ввода!!!' if result < limit && result > 3

      if result == 1
        @player.more_card(@deck_cards.more_card)
        dealer_actions
      end
      if result == 2
        @player.skip_move
        dealer_actions
      end
      if result == 3
        @player.open_cards
        @dealer.open_cards
        if @player.points <= 21 && (@player.points > @dealer.points || @dealer.points > 21)
          puts ['Вы победили!!!', "У вас #{@player.points}", "У дилера #{@dealer.points}"]
          reset_values
          @player.bank += @player.rate * 2
          puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}"]
          start_game unless @player.bank.zero? || @dealer.bank.zero?

        elsif @player.points ==  @dealer.points || (@player.points > 21 && @dealer.points > 21)
          puts ['Ничья.', "У вас #{@player.points}", "У дилера #{@dealer.points}"]
          reset_values
          @player.bank += @player.rate
          @dealer.bank += @dealer.rate
          puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}"]
          start_game unless @player.bank.zero? || @dealer.bank.zero?
        else
          puts ['Вы проиграли.', "У вас #{@player.points}", "У дилера #{@dealer.points}", "Банк #{@dealer.bank}"]
          reset_values
          @dealer.bank += @dealer.rate * 2
          puts ["Ваш банк: #{@player.bank}","Банк дилера: #{@dealer.bank}"]
          start_game unless @player.bank.zero? || @dealer.bank.zero?
        end
      end
    end
    @player.bank.zero? ? (puts 'Вы банкрот :(') : (puts 'Дилер банкрот. Вы чемпион!!!')
    restart_game
  end

  def reset_values
    [@player, @dealer].each{ |user| user.reset_values}
    @deck_cards.shuffle_deck
  end

  def restart_game
    puts 'Введите'
    puts '1 - Играть еще раз'
    puts '2 - Выход'
    result = gets.chomp.to_i
    if result == 1
      @player.bank = 100
      @dealer.bank = 100
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
    end
  end
end
