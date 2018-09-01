class Game < ApplicationRecord
  attr_accessor :messages
  has_many :user_games
  has_many :users, through: :user_games

  enum current_turn: ["challenger", "opponent"]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_board, presence: true
  validates :player_2_board, presence: true
end
