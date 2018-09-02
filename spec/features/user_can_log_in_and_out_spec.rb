require 'rails_helper'

describe 'as a user' do
  context 'after logging into account' do
    it 'can log out' do
      user = create(:user)

      visit root_path

      click_on 'Login'
      fill_in :email, with: user.email
      fill_in :password, with: 'supsecret'
      click_on 'Submit'

      expect(current_path).to eq('/dashboard')

      expect(page).to have_content("Logged in as #{user.username}")
      expect(page).to have_link('Logout')

      click_on 'Logout'

      expect(current_path).to eq(root_path)
      expect(page).to have_link('Login')
      expect(page).to have_content('You are now logged out!')
      expect(page).to_not have_link('Logout')
    end
  end
  context 'trying to log into account with wrong credentials' do
    it 'receives an error and rerenders the login page' do
      user = create(:user)

      visit root_path

      click_on 'Login'
      fill_in :email, with: user.email
      fill_in :password, with: 'nottherightpassword'
      click_on 'Submit'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Invalid email and/or password.')
    end
  end
end
