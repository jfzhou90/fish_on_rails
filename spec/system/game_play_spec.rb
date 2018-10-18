# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game Setup', type: :system do
  let(:session1) { Capybara::Session.new(:rack_test, Rails.application) }
  let(:session2) { Capybara::Session.new(:rack_test, Rails.application) }
  let(:refresh) { [session1.driver, session2.driver].each(&:refresh) }

  before do
    driven_by(:rack_test)
  end

  describe('Starts a playable game.') do
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
        session.click_on 'Play'
      end
    end

    it('expect cards on each player when game start') do
      expect(session2).to have_css('.player__card--big')
      expect(session2).to have_css('.fake__card--card')
    end

    it('be able to play the game with 2 players') do
      refresh
      session1.first('.label__player').click
      session1.first('.card__container').click
      session1.click_on 'Play'
      refresh
      expect(session1).to_not have_css('.play__round')
      expect(session2).to have_css('.play__round')
    end
  end

  describe('bots') do
    before do
      User.create(username: 'username',
                  password: 'password',
                  password_confirmation: 'password')
      visit '/'
      fill_in :username, with: 'username'
      fill_in :password, with: 'password'
      click_on 'Login'
      click_on 'Play'
      fill_in 'game_player_count', with: 2
      click_on 'Play'
    end
    it('starts a game with a bot') do
      sleep(1)
      page.driver.refresh
      expect(page).to have_content('FisherBot1')
    end
  end
end
