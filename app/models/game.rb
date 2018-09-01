class Game < ApplicationRecord
  validates :player_1_board, presence: true
  validates :player_2_board, presence: true
  has_many :user_games
  has_many :users, through: :user_games

  enum current_turn: %i[challenger opponent]

  serialize :player_1_board
  serialize :player_2_board
end
