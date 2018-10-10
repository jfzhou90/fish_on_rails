# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  before do
    driven_by(:rack_test)
    visit '/'
    click_on 'Sign up'
    fill_in 'Username', with: 'usernameA'
    fill_in 'New Password', with: 'passwordB'
  end

  it 'successful sign up' do
    fill_in 'Confirm Password', with: 'passwordB'
    click_on 'Sign up'
    expect(current_path).to eq '/menu'
    expect(page).to have_content('Leaderboard')
  end

  it 'proceed to menu page' do
    fill_in 'Confirm Password', with: 'passwordC'
    click_on 'Sign up'
    expect(page).to have_content(/Unable to create user/)
  end

  it 'cancel return to login page' do
    click_on 'Cancel'
    expect(current_path).to eq('/')
  end
end
