# frozen_string_literal: true

class PlayingCard
  attr_reader :rank, :suit
  def initialize(rank: 'Ace', suit: 'Spades')
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  def rank_equal(other)
    rank == other.rank
  end

  def as_json
    {
      rank: rank,
      suit: suit
    }
  end

  def self.from_json(card_json)
    PlayingCard.new(rank: card_json['rank'], suit: card_json['suit'])
  end
end
