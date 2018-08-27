require 'rails_helper'

describe 'as a guest' do
  context 'when I visit /' do
    it 'can register with email' do
      visit '/'

      click_on 'Register'

      expect(current_path).to eq('/register')
    end
  end
end
