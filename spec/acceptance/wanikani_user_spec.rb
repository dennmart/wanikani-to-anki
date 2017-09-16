require 'spec_helper'

describe 'WaniKani User' do
  let(:valid_api_key) { 'fe1d61e66c3a8421db3b8fdbff4fa522' } # koichi's API key, as given in the WaniKani forums.

  describe 'Logging in' do
    before(:each) do
      visit '/'
    end

    it 'displays an error message if the API key is invalid' do
      fill_in 'wanikani_api_key', with: 'invalid-api-key'
      click_button 'Let\'s Go!'
      expect(page).to have_content('Bummer...')
    end

    it 'logs in successfully if the API key is valid and displays the user name' do
      fill_in 'wanikani_api_key', with: valid_api_key
      click_button 'Let\'s Go!'
      expect(page).to have_content('Hi, koichi!')
    end
  end

  describe 'Logging out' do
    it "should log out successfully when clicking on the 'Not <username>?' page" do
      visit '/'
      fill_in 'wanikani_api_key', with: valid_api_key
      click_button 'Let\'s Go!'
      click_link '(Not koichi?)'
      expect(page).to have_content('Enter your WaniKani API Version 1 key to get started')
    end
  end
end
