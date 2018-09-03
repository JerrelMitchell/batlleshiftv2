class TurnProcessor
  def initialize(game, target, player_type)
    @game   = game
    @target = target
    @player_type = player_type
    @messages = []
    @message_generator = MessageGenerator
  end

  def correct_turn?
    @game.current_turn == @player_type
  end

  def valid_target
    @game.player_1_board.space_names.include?(@target)
  end

  def game_over?
    @game.player_1_board.all_sunk? || @game.player_2_board.all_sunk?
  end

  def run!
    if @game.challenger? && correct_turn? && valid_target
      attack_opponent
      @game.opponent! unless fired_on?
    elsif @game.opponent? && correct_turn? && valid_target
      attack_challenger
      @game.challenger! unless fired_on?
    else
      @messages << MessageGenerator.invalid_attack
    end
    @game.save!
  end

  def fired_on?
    @shooter.fired_on? if @shooter
  end

  def message
    @messages.join(' ')
  end

  def attack_opponent
    shooter = shooter(@game.player_2_board)
    @game.player_2_board.add_sunken_ship if shooter.message.include?('sunk.')
    generate_message(shooter.message)
  end

  def attack_challenger
    shooter = shooter(@game.player_1_board)
    @game.player_1_board.add_sunken_ship if shooter.message.include?('sunk.')
    generate_message(shooter.message)
  end

  def generate_message(result)
    if @game.player_1_board.all_sunk? || @game.player_2_board.all_sunk?
      @messages << @message_generator.game_over_shot
    else
      @messages << @message_generator.shot_result(result)
    end
  end

  private

  def shooter(board)
    @shooter ||= Shooter.fire!(board: board, target: @target)
  end
end
