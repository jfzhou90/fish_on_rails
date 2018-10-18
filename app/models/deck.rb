# frozen_string_literal: true

require_relative('./playing_card')

class CardDeck
  def initialize(cards: CardDeck.create_deck_of_cards)
    @cards_left = cards
  end

  def deal
    cards_left.pop
  end

  def shuffle
    cards_left.shuffle!
  end

  def deck_size
    cards_left.length
  end

  def empty?
    cards_left.empty?
  end

  def as_json
    {
      cards: cards_left.map(&:as_json)
    }
  end

  def self.from_json(deck_json)
    cards = deck_json['cards'].map { |data| PlayingCard.from_json(data) }
    CardDeck.new(cards: cards)
  end

  def self.create_deck_of_cards
    suits = %w[Clubs Diamonds Hearts Spades]
    ranks = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]
    ranks.flat_map do |rank|
      suits.map do |suit|
        PlayingCard.new(rank: rank, suit: suit)
      end
    end
  end

  private

  attr_reader :cards_left
end

# this is for testing.
class TestDeck < CardDeck
  attr_accessor :cards_left

  def initialize
    @cards_left = create_deck_of_cards
  end

  def shuffle
    # test deck dont shuffle
  end

  def shuffle_test
    cards_left.shuffle!
  end

  def create_deck_of_cards
    suits = %w[Clubs Diamonds Hearts Spades]
    ranks = %w[2 3 4 King Ace]
    ranks.flat_map do |rank|
      suits.map do |suit|
        PlayingCard.new(rank: rank, suit: suit)
      end
    end
  end
end
