class Api::V1::Games::ShotsController < ApiController
  def create
    # turn_processor.run!
    # render json: turn_processor.game, status: turn_processor.status, message: turn_processor.message

    if current_user
      correct_turn = current_user.user_games.first.player_type == game.current_turn
      turn_processor.run!
      if game.winner
        render json: game, status: :bad_request, message: "Invalid move. Game over."
      elsif correct_turn
        if valid_coordinates
          if turn_processor.game_over?
            game.update(winner: current_user.email)
            render json: game, status: :ok, message: turn_processor.message
          else
            render json: game, status: :ok, message: turn_processor.message
          end
        elsif !valid_coordinates
          render json: game, status: :bad_request, message: "Invalid coordinates"
        end
      elsif !correct_turn
        render json: game, status: :bad_request, message: "Invalid move. It's your opponent's turn"
      end
    else
      render json: game, status: :unauthorized, message: "Unauthorized"
    end
  end

  private

  def valid_coordinates
    @valid_coordinates ||= game.player_1_board.space_names.include?(params[:shot][:target])
  end

  def turn_processor
    @turn_processor ||= TurnProcessor.new(game, params[:shot][:target], current_user.user_games.first.player_type)
  end

  def game
    @game ||= Game.find(params[:game_id])
  end
end
