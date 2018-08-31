class TurnProcessor
  def initialize(game, target, player_type)
    @game   = game
    @target = target
    @player_type = player_type
    @messages = []
  end

  def correct_turn?
    game.current_turn == player_type
  end

  def valid_target
    game.player_1_board.space_names.include?(target)
  end

  def game_over?
    game.player_1_board.all_sunk? || game.player_2_board.all_sunk?
  end

  def run!
    if game.current_turn == "challenger" && correct_turn? && valid_target
      attack_opponent
      game.current_turn = "opponent"
    elsif game.current_turn == "opponent" && correct_turn? && valid_target
      attack_challenger
      game.current_turn = "challenger"
    end
      game.save!
  rescue MessageGenerator => e
    @messages << e.message
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target, :player_type

  def player
    Player.new(game.player_1_board)
  end

  def opponent
    Player.new(game.player_2_board)
  end

  def attack_opponent
    result = Shooter.fire!(board: opponent.board, target: target)
    if result.include?("sunk.")
      game.player_2_board.add_sunken_ship
    end
    generate_message(result)
  end

  def attack_challenger
    result = Shooter.fire!(board: player.board, target: target)
    generate_message(result)
  end

  def generate_message(result)
    if game.player_2_board.all_sunk?
      @messages << "Your shot resulted in a #{result} Game over."
    else
      @messages << "Your shot resulted in a #{result}."
    end
  end
end
