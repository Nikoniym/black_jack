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
    @controller = Controller.new(@player)
    start_game
  end

  private

  def start_game
    @controller.distribution_cards
    gameplay
  end

  def gameplay
    loop do
      break if @controller.banks_zero?
      input_user
      game_actions
    end
    @player.bank.zero? ? (puts 'Вы банкрот :(') : (puts 'Дилер банкрот. Вы чемпион!!!')
    restart_game
  end

  def input_user
    puts 'Введите:'
    puts '1 - Добавить карту' if @controller.player_more?
    puts '2 - Пропустить' if @controller.player_miss?
    puts '3 - Открыть карты'
    @result = gets.chomp.to_i
  end

  def game_actions
    if @result == 1 && @controller.player_more?
      @controller.more_card
    elsif  @result == 2 && @controller.player_miss?
      @controller.skip_move
    elsif @result == 3
      @controller.open_cards
    else
      puts ['Ошбика ввода!!!', '']
    end
  end

  def restart_game
    puts ['Введите:', '1 - Играть еще раз', '2 - Выход']
    result = gets.chomp.to_i
    if result == 1
      @controller.reset_banks
      start_game
    elsif result == 2
      exit
    else
      puts 'Ошибка ввода!!!'
      restart_game
    end
  end
end
