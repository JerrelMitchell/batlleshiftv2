class Api::V1::GamesController < ActionController::API

  def show
    game = Game.find_by(id: params[:id])
    if game
      render json: game
    else
      render status: :bad_request
    end
  end

  def create
    render json: Game.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
  end
end
