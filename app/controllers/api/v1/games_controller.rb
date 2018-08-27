class Api::V1::GamesController < ActionController::API

  def show
    game = Game.find_by(id: params[:id])
    if game
      render json: game
    else
      render status: :bad_request
    end
  end
end
