# frozen_string_literal: true

FactoryBot.define do
  factory :game_user do
    games { nil }
    users { nil }
  end
end
