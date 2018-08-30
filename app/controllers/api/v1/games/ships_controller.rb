class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    if request.headers.env.keys.include?('HTTP_X_API_KEY')
      board = game.player_2_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(player_2_board: ship_placer.board, current_turn: 0)
      render json: game
    else
      board = game.player_1_board
      ship_placer = ShipPlacer.new(board: board, ship: board.get_ship, start_space: params[:start_space], end_space: params[:end_space])
      ship_placer.ship.place(params[:start_space], params[:end_space])
      ship_placer.run
      game.update(player_1_board: ship_placer.board, current_turn: 1)
      render json: game, message: MessageGenerator.new.place_ship(params[:ship_size], board.ships_to_place)
    end
  end
end
