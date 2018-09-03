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
      @game.opponent!
    elsif @game.opponent? && correct_turn? && valid_target
      attack_challenger
      @game.challenger!
    else
      @messages << MessageGenerator.invalid_attack
    end
    @game.save!
  end

  def message
    @messages.join(' ')
  end

  def attack_opponent
    result = Shooter.fire!(board: @game.player_2_board, target: @target)
    @game.player_2_board.add_sunken_ship if result.include?('sunk.')
    generate_message(result)
  end

  def attack_challenger
    result = Shooter.fire!(board: @game.player_1_board, target: @target)
    @game.player_1_board.add_sunken_ship if result.include?('sunk.')
    generate_message(result)
  end

  def generate_message(result)
    if @game.player_1_board.all_sunk? || @game.player_2_board.all_sunk?
      @messages << @message_generator.game_over_shot
    else
      @messages << @message_generator.shot_result(result)
    end
  end
end
