class User < ApplicationRecord
  validates_presence_of :username, :email, :password_digest
  validates_uniqueness_of :email, :auth_token, :activation_token

  has_many :user_games
  has_many :games, through: :user_games

  enum status: %i[inactive active]

  has_secure_password
  has_secure_token :activation_token
  has_secure_token :auth_token

  def player_type
    user_games.first.player_type
  end
end
