require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password_digest }
    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :auth_token }
    it { should validate_uniqueness_of :activation_token }
  end

  context 'relationships' do
    it { should have_many :games }
    it { should have_many :user_games }
  end

  context '#methods' do
    before(:each) do
      @user = create :user
      player_1_board = Board.new(4)
      player_2_board = Board.new(4)

      @game_attributes = {
        player_1_board: player_1_board,
        player_2_board: player_2_board,
        current_turn: 'challenger'
      }
      @user.games.create!(@game_attributes)
    end
    it 'returns #player_type belonging to game through user_game join table' do
      expect(@user.player_type).to eq(@game_attributes[:current_turn])
    end
  end
end
