class Game < ApplicationRecord
  has_many :user_games
  has_many :users, through: :user_games
  attr_accessor :messages

  enum current_turn: %i[challenger opponent]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_board, presence: true
  validates :player_2_board, presence: true
end
