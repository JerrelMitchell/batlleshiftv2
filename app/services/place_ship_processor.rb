class PlaceShipProcessor
  attr_reader :game,
              :user,
              :game_info,
              :message,
              :status,
              :player_type

  def initialize(game_info, user)
    @game = user.games.find(game_info[:game_id]) if user
    @user = user
    @game_info = game_info
    @player_type = user.player_type(@game.id) if user
    @status = 200
    @message = ''
  end

  def current_board
    if player_type == 'challenger'
      @board ||= game.player_1_board
    elsif player_type == 'opponent'
      @board ||= game.player_2_board
    end
  end

  def next_turn
    return 1 if current_board.ships.empty? && game.challenger?
    return 0 if current_board.ships.empty? && game.opponent?
    player - 1
  end

  def player
    return 1 if player_type == 'challenger'
    return 2 if player_type == 'opponent'
  end

  def place_ship_on_correct_board
    if game
      ship_placer.run
      ship_placed
    end
  end

  def ship_placed
    @status = 200
    @message = MessageGenerator.place_ship(game_info[:ship_size], current_board.ships)
  end

  private

  def ship_placer
    @ship_placer ||= ShipPlacer.new(board: current_board, ship: current_board.find_ship, start_space: game_info[:start_space], end_space: game_info[:end_space])
  end
end
