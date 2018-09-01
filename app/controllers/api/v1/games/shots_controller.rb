class Api::V1::Games::ShotsController < ApiController
  def create
    game = Game.find(params[:game_id])
    user = game.users.find_by(auth_token: request.headers.env['HTTP_X_API_KEY'])
    if user
      correct_turn = user.user_games.first.player_type == game.current_turn
      valid_coordinates = game.player_1_board.space_names.include?(params[:shot][:target])
      turn_processor = TurnProcessor.new(game, params[:shot][:target], user.user_games.first.player_type)

      turn_processor.run!
      if game.winner
        render json: game, status: :bad_request, message: "Invalid move. Game over."
      elsif correct_turn
        if valid_coordinates
          if turn_processor.game_over?
            game.update(winner: user.email)
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
end
