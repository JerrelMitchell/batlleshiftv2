
class PlaceShipPresenter
  attr_reader :game,
              :user,
              :game_info,
              :message,
              :status,
              :player_type

  def initialize(game_info, current_user)
    @game = current_user.games.find(game_info[:game_id]) if current_user
    @user = current_user
    @game_info = game_info
    @player_type = current_user.user_games.first.player_type
    @status = 401
  end

  def current_board
    if player_type == 'challenger'
      @board ||= game.player_1_board
    elsif player_type == 'opponent'
      @board ||= game.player_2_board
    end
  end

  def next_turn
    return 1 if current_board.ships_to_place.empty? && game.challenger?
    return 0 if current_board.ships_to_place.empty? && game.opponent?
    player - 1
  end

  def player
    return 1 if player_type == 'challenger'
    return 2 if player_type == 'opponent'
  end

  def place_ship_on_correct_board
    if game
      ship_placer.ship.place(game_info[:start_space], game_info[:end_space])
      ship_placer.run
      @message = MessageGenerator.new.place_ship(game_info[:ship_size], current_board.ships_to_place)
      @status = 200
    end
  end

  private

  def ship_placer
    @ship_placer ||= ShipPlacer.new(board: current_board, ship: current_board.get_ship, start_space: game_info[:start_space], end_space: game_info[:end_space])
  end
end
