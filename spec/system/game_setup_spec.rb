# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game Setup', type: :system do
  let(:session1) { Capybara::Session.new(:rack_test, Rails.application) }
  let(:session2) { Capybara::Session.new(:rack_test, Rails.application) }
  let(:login) do
    User.create(username: 'usernameA',
                password: 'passwordB',
                password_confirmation: 'passwordB')
    visit '/'
    fill_in :username, with: 'usernameA'
    fill_in :password, with: 'passwordB'
    click_on 'Login'
  end

  before do
    driven_by(:rack_test)
  end

  describe('User interface') do
    before do
      login
      click_on 'Play'
    end

    it('renders the correct path') do
      expect(current_path).to eq('/games/new')
    end

    it('able to change how many players') do
      fill_in 'game_player_count', with: 3
      expect(page.find('#game_player_count').value). to eq('3')
    end
  end

  describe('Creating a game, and joining with 2 session') do
    before do
      [session1, session2].each_with_index do |session, index|
        User.create(username: "username#{index}",
                    password: 'password',
                    password_confirmation: 'password')
        session.visit '/'
        session.fill_in :username, with: "username#{index}"
        session.fill_in :password, with: 'password'
        session.click_on 'Login'
        session.click_on 'Play'
        session.fill_in 'game_player_count', with: 2
      end
    end

    it('start a game with 2 players') do
      session1.click_on 'Play'
      expect(Game.pending.count).to be(1)
      session2.click_on 'Play'
      expect(Game.pending.count).to be(0)
      expect(Game.in_progress.count).to be(1)
    end
  end
end
