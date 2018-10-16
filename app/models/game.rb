# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  scope :pending, -> { where(started_at: nil) }
  scope :in_progress, -> { where.not(started_at: nil).where(finished_at: nil) }

  def start_if_possible(current_user)
    users << current_user
    add_player_to_game(current_user.username)
    start_game if player_count == users.count && started_at.nil?
  end

  def create_gofish_if_possible
    return false unless gofish.nil?

    update(gofish: GoFishGame.new.as_json)
    Thread.start do
      sleep(15)
      start_game_with_bots
    end
  end

  def start_game_with_bots
    return if started_at

    game = GoFishGame.from_json(gofish)
    game.fill_game_with_bots(player_count)
    update!(gofish: game.as_json, started_at: Time.zone.now)
    Pusher.trigger("game#{id}", 'refresh', { message: 'refresh' })
  end

  def add_player_to_game(name)
    gofish_game = GoFishGame.from_json(gofish)
    gofish_game.add_player(name)
    update!(gofish: gofish_game.as_json)
  end

  def start_game
    gofish_game = GoFishGame.from_json(gofish)
    gofish_game.start
    update!(gofish: gofish_game.as_json, started_at: Time.zone.now)
  end

  def self.get_game(id)
    GoFishGame.from_json(Game.find(id).gofish)
  end

  def play_round(player, rank)
    gofish_game = GoFishGame.from_json(gofish)
    gofish_game.play_round(player, rank)
    update!(gofish: gofish_game.as_json, started_at: Time.zone.now)
  end
end
