class User < ApplicationRecord
  has_many :user_games
  has_many :games, through: :user_games
  validates_presence_of :username, :email, :password_digest
  validates_uniqueness_of :email, :auth_token, :activation_token
  has_secure_password
  has_secure_token :activation_token
  has_secure_token :auth_token
  enum status: [:inactive, :active]
end
