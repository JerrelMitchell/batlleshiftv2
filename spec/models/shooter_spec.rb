require 'rails_helper'

RSpec.describe Shooter do
  context '#methods' do
    it 'can use logic to determine valid shots with #fire!' do
      user = create :user
      player_1_board  = Board.new(4)
      player_2_board  = Board.new(4)
      game_attributes = { player_1_board: player_1_board,
                          player_2_board: player_2_board,
                          current_turn: 'challenger' }
      user.games.create!(game_attributes)

      shooter = Shooter.new(board: player_2_board, target: 'A10')

      expect { shooter.fire! }.to raise_error(RuntimeError, 'Invalid coordinates')
    end
  end
end
