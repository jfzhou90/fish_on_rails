# frozen_string_literal: true

require 'spec_helper'
require './app/models/playing_card'

RSpec.describe PlayingCard do
  let(:card1) { PlayingCard.new }
  let(:card2) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:card3) { PlayingCard.new(rank: 2, suit: 'Hearts') }
  let(:card4) { PlayingCard.new(rank: 2, suit: 'Hearts') }
  let(:json_data) { card1.as_json }
  let(:inflated_card) { PlayingCard.from_json(JSON.parse(json_data.to_json)) }

  describe('#initialize') do
    it('create a card with default rank and suit if no arguments input') do
      expect(card1.rank).to eq('Ace')
      expect(card1.suit).to eq('Spades')
    end

    it('take in arguments to create specific rank and suit') do
      expect(card3.rank).to eq(2)
      expect(card3.suit).to eq('Hearts')
    end
  end

  describe('#to_s') do
    it('read the card in human readable way') do
      expect(card1.to_s).to eq('Ace of Spades')
      expect(card2.to_s).to eq('Ace of Clubs')
      expect(card3.to_s).to eq('2 of Hearts')
    end
  end

  describe('#==') do
    it('compare cards to see if they are equal rank and suit') do
      expect(card1 == card2).to be(false)
      expect(card3 == card4).to be(true)
    end
  end

  describe('#rank_equal') do
    it('compare cards to see if the rank matches') do
      expect(card1.rank_equal(card3)).to be(false)
      expect(card1.rank_equal(card2)).to be(true)
    end
  end

  describe('#as_json') do
    it('returns a json object') do
      expect(json_data).to eq({ rank: 'Ace', suit: 'Spades' })
    end

    it('json object keys are strings') do
      expect(JSON.parse(json_data.to_json)['rank']).to eq('Ace')
    end
  end

  describe('#from_json') do
    it('creates class object using json data') do
      expect(inflated_card).to be_instance_of(PlayingCard)
    end

    it('able to use instance methods') do
      expect(inflated_card.rank).to eq('Ace')
      expect(inflated_card.to_s).to eq('Ace of Spades')
    end
  end
end
