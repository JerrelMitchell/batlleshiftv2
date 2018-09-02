require 'rails_helper'

describe Game, type: :model do
  context 'relationships' do
    it { should have_many :users }
    it { should have_many :user_games }
  end
end
