require 'rails_helper'

describe 'as a guest' do
  context 'when I visit /' do
    it 'can register with email' do
      visit '/'

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in 'email', with: 'ste@examp.com'
      fill_in 'username', with: 'bob'
      fill_in 'password', with: 'ggg'
      fill_in 'password_confirmation', with: 'ggg'

      click_on 'Register'

      expect(current_path).to eq('/dashboard')

    end
  end
end
