# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users
end
