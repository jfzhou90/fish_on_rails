# frozen_string_literal: true

class GameUser < ApplicationRecord
  belongs_to :game
  belongs_to :user
  validates :user, uniqueness: { scope: :game, message: 'One Game User Per Game' }
end
