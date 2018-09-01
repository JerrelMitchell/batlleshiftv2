class Api::V1::GamesController < ApiController
  def show
    if find_game
      render json: find_game
    else
      render status: :bad_request
    end
  end

  def create
    new_game = set_game_boards
    new_game.user_games.create(user_id: user2.id, player_type: 'opponent')
    render json: new_game
  end

  private

  def set_game_boards
    current_user.games.create(player_1_board: Board.new, player_2_board: Board.new)
  end

  def find_game
    @find_game ||= Game.find_by(id: params[:id])
  end

  def user2
    @user2 ||= User.find_by(email: params[:opponent_email])
  end
end
