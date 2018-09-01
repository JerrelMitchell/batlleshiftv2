class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum player_type: %i[challenger opponent]
end
