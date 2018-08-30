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
    user1 = User.find_by(auth_token: request.headers.env['HTTP_X_API_KEY'])
    user2 = User.find_by(email: params[:opponent_email])
    game = user1.games.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
    game.user_games.create(user_id: user2.id, player_type: 1)
    render json: game
  end
end
