class Api::V1::GamesController < ActionController::API
  def show
    if find_game
      render json: find_game
    else
      render status: :bad_request
    end
  end

  def create
    new_game = set_game_boards
    new_game.user_games.create(user_id: user_2.id, player_type: 1)
    render json: new_game
  end

  private

  def set_game_boards
    user_1.games.create(player_1_board: Board.new, player_2_board: Board.new)
  end

  def find_game
    Game.find_by(id: params[:id])
  end

  def user_1
    User.find_by(auth_token: request.headers.env['HTTP_X_API_KEY'])
  end

  def user_2
    User.find_by(email: params[:opponent_email])
  end
end
