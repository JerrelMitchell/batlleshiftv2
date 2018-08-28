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

      click_on 'Submit'

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content('Logged in as bob')
      expect(page).to have_content('This account has not yet been activated. Please check your email.')

      visit '/activation/1'

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content('Thank you! Your account is now activated.')
      expect(page).to have_content('Status: Active')
    end
  end
end
