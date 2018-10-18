# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users
  # belongs_to: winner, class_name: 'User'

  scope :pending, -> { where(started_at: nil) }
  scope :in_progress, -> { where.not(started_at: nil).where(finished_at: nil) }
  scope :finished, -> { where(finished_at: nil) }

  def create_gofish_if_possible
    return false unless gofish.nil?

    update(gofish: GoFishGame.new.as_json)
    Thread.start do
      sleep(Rails.env.test? ? 1 : 15)
      start_game_with_bots
    end
  end

  def start_game_with_bots
    return if started_at

    gofish_game.fill_game_with_bots(player_count)
    update!(gofish: gofish_game.as_json, started_at: Time.zone.now)
    Pusher.trigger("game#{id}", 'refresh', { message: 'refresh' })
  end

  def gofish_game
    @gofish_game ||= GoFishGame.from_json(gofish)
  end

  def add_player_to_game(current_user)
    users << current_user
    gofish_game.add_player(current_user.username)
    update!(gofish: gofish_game.as_json)
    Pusher.trigger("game#{id}", 'refresh', { message: 'refresh' })
  end

  def start_if_possible
    return unless player_count == users.count && started_at.nil?

    gofish_game.start
    update!(gofish: gofish_game.as_json, started_at: Time.zone.now)
  end

  def self.get_game(id)
    GoFishGame.from_json(Game.find(id).gofish)
  end

  def play_round(player, rank)
    gofish_game.play_round(player, rank)
    update!(gofish: gofish_game.as_json)
    update!(finished_at: Time.zone.now) if gofish_game.ended
  end
end
