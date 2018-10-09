# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'How_to_Play', type: :system do
  let(:init) do
    User.create(username: 'usernameA',
                password: 'passwordB',
                password_confirmation: 'passwordB')
    visit '/'
    fill_in :username, with: 'usernameA'
    fill_in :password, with: 'passwordB'
    click_on 'Login'
    click_on 'How to Play'
  end

  before do
    driven_by(:rack_test)
  end

  it('how to play have a title How to Play') do
    init
    expect(page).to have_content('How to Play')
  end

  it('how to play have a got it button and redirects to menu') do
    init
    click_on 'Got It'
    expect(page).to have_content(/Welcome/)
    expect(page).to have_current_path('/')
  end
end
