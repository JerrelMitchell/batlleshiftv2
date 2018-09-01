class Api::V1::Games::ShipsController < ApiController
  def create
    presenter = PlaceShipPresenter.new(placement_params, current_user)
    presenter.place_ship_on_correct_board
    game.update("player_#{presenter.player}_board" => presenter.current_board,
                "current_turn" => presenter.next_turn)
    render json: game, status: presenter.status, message: presenter.message
  end

  private

  def game
    @game ||= Game.find(placement_params[:game_id])
  end

  def placement_params
    params.permit(:game_id, :ship_size, :start_space, :end_space)
  end

end
