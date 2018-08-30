class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    user = game.users.find_by(auth_token: request.headers.env['HTTP_X_API_KEY'])
    if user.user_games.first.player_type == "challenger"
      board = game.player_1_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(current_turn: 1) if game.player_1_board.ships_to_place.empty?
      game.update(player_1_board: ship_placer.board)
      render json: game, message: MessageGenerator.new.place_ship(params[:ship_size], board.ships_to_place)
    elsif user.user_games.first.player_type == "opponent"
      board = game.player_2_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(current_turn: 0) if game.player_1_board.ships_to_place.empty?
      render json: game, message: MessageGenerator.new.place_ship(params[:ship_size], board.ships_to_place)
    end
  end
end
