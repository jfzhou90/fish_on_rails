# frozen_string_literal: true

class GameUser < ApplicationRecord
  belongs_to :game
  belongs_to :user
end
