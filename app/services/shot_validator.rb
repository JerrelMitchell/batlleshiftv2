
class ShotValidator
  attr_reader :game,
              :user,
              :processor,
              :status,
              :message,
              :target,
              :winner

  def initialize(shot_info, user, processor)
    @target = shot_info[:target]
    @game = user.games.find(shot_info[:game_id]) if user
    @processor = processor
    @user = user
  end

  def unauthorized?
    if @user
      processor.run!
      false
    else
      invalid_unauthorized
      true
    end
  end

  def game_over?
    if game.winner
      invalid_game_over
      return true
    end
    false
  end

  def wrong_turn?
    return false if user.player_type == game.current_turn
    invalid_opponents_turn
    true
  end

  def wrong_coordinates?
    if game.player_1_board.space_names.include?(target)
      status_ok
      false
    else
      invalid_coordinates
      true
    end
  end

  def invalid_unauthorized
    @status = 401
    @message = "Unauthorized"
  end

  def invalid_opponents_turn
    @status = 400
    @message = "Invalid move. It's your opponent's turn"
  end

  def status_ok
    @winner = @user.email if @processor.game_over?
    @status = 200
    @message = @processor.message
  end

  def invalid_game_over
    @status = 400
    @message = "Invalid move. Game over."
  end

  def invalid_coordinates
    @status = 400
    @message = "Invalid coordinates"
  end

  def run
    return self if unauthorized?
    return self if game_over?
    return self if wrong_turn?
    return self if wrong_coordinates?
    self
  end
end
