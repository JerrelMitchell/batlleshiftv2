require 'rails_helper'

RSpec.describe Board do
  context '#methods' do
    it 'can add to sunk ship counter with #add_sunken_ship' do
      board = Board.new
      expect(board.sunk_ships).to eq(0)
      board.add_sunken_ship

      expect(board.sunk_ships).to eq(1)
    end
  end
end
