require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'relationships' do
    it { should have_many :users }
    it { should have_many :user_games }
  end
end
