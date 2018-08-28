class User < ApplicationRecord
  has_secure_password
  enum status: [:inactive, :active]
end
