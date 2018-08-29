class User < ApplicationRecord
  validates_presence_of :username, :email, :password_digest
  validates_uniqueness_of :email, :auth_token, :activation_token
  has_secure_password
  has_secure_token :activation_token
  has_secure_token :auth_token
  enum status: [:inactive, :active]
end
