# frozen_string_literal: true

require('rails_helper')
require('./app/models/deck')

describe(CardDeck) do
  let(:deck) { CardDeck.new }
  let(:deck_json) { deck.as_json }
  let(:inflated_deck) { CardDeck.from_json(JSON.parse(deck_json.to_json)) }

  describe('#initialize') do
    it('starts the deck with 52 cards') do
      expect(deck.deck_size).to be(52)
    end
  end

  describe('#Deal') do
    it('removes a card from the deck') do
      card = deck.deal
      expect(deck.deck_size).to be(51)
      expect(card).to be_an_instance_of(PlayingCard)
    end
  end

  describe('#shuffle') do
    it('shuffles the deck into a random order, may fail if shuffled is the same as non-shuffled') do
      deck.shuffle
      card = deck.deal
      card2 = PlayingCard.new
      expect(card == card2).to be(false)
    end
  end

  describe('#as_json') do
    it('creates a json object for deck with 52 cards') do
      expect(deck_json.to_json).to match(/cards/)
    end
  end

  describe('#from_json') do
    it('creates a deck class from json object') do
      expect(inflated_deck).to be_instance_of(CardDeck)
    end

    it('inflated deck can use instance method') do
      expect(inflated_deck.deck_size).to be(52)
    end

    it('dealt card from inflated deck are PlayingCard instances') do
      expect(inflated_deck.deal).to be_instance_of(PlayingCard)
    end
  end
end
