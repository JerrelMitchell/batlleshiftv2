class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    ship_placer = ShipPlacer.new(game.player_1_board, Ship.new(params[:ship_size]), params[:start_space], params[:end_space])
    ship_placer.run
    game.update(player_1_board: ship_placer.board, current_turn: 1)
    render json: game
  end
end
