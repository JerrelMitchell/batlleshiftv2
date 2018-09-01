class Api::V1::Games::ShipsController < ApiController
  def create
    presenter = PlaceShipPresenter.new(params[:game_id], current_user).authenticate

    game = current_user.games.find(params[:game_id]) if current_user

    if current_user.user_games.first.player_type == "challenger"
      board = game.player_1_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(current_turn: 1) if game.player_1_board.ships_to_place.empty?
      game.update(player_1_board: ship_placer.board)
      render json: game, message: MessageGenerator.new.place_ship(params[:ship_size], board.ships_to_place)
    elsif current_user.user_games.first.player_type == "opponent"
      board = game.player_2_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(current_turn: 0) if game.player_1_board.ships_to_place.empty?
      render json: game, message: MessageGenerator.new.place_ship(params[:ship_size], board.ships_to_place)
    end
  end
end

class PlaceShipPresenter

  def initialize(game_id, current_user)
    @game = current_user.games.find(game_id) if current_user
    @user = current_user
  end

  def authenticate
    return self unless @game.nil?
  end
end
