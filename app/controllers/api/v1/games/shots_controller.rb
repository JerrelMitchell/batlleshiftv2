class Api::V1::Games::ShotsController < ApiController
  def create
    presenter = ShotPresenter.new(shot_params, current_user, turn_processor).run
    game.update(winner: presenter.winner, current_turn: 2) if presenter.winner
    render json: game, status: presenter.status, message: presenter.message
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def shot_params
    params.permit(:target, :game_id)
  end

  def turn_processor
    @turn_processor ||= TurnProcessor.new(game, shot_params[:target],
                                      current_user.player_type(game.id)) if current_user
  end
end
