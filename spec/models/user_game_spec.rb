require 'rails_helper'

RSpec.describe UserGame, type: :model do
  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end
end
