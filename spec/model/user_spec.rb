require 'rails_helper'

describe User, type: :model do
  context 'validations' do
  it {should validate_presence_of :username }
  it {should validate_presence_of :email}
  it {should validate_presence_of :password_digest }
  it {should validate_uniqueness_of :email }
  it {should validate_uniqueness_of :auth_token }
  it {should validate_uniqueness_of :activation_token }
  end
end
