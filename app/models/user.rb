# frozen_string_literal: true

class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users

  validates :username,
            presence: true,
            length: { minimum: 8, maximum: 16 },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,
            presence: true,
            confirmation: true,
            format: { without: /\s/ },
            length: { minimum: 8, maximum: 16 }
end
