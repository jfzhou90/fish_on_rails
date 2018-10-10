# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  before do
    driven_by(:rack_test)
    User.create(username: 'usernameA',
                password: 'passwordB',
                password_confirmation: 'passwordB')
    visit '/'
    fill_in :username, with: 'usernameA'
  end

  it 'requires authentication' do
    fill_in :password, with: 'passwordC'
    click_on 'Login'
    expect(current_path).to eq '/'
    expect(page).to have_content('Login to Play')
  end

  it 'proceed to menu page' do
    fill_in :password, with: 'passwordB'
    click_on 'Login'
    expect(current_path).to eq '/menu'
  end
end
