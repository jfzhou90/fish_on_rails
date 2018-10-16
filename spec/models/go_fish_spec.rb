# frozen_string_literal: true

require('spec_helper')
require('./app/models/gofish_game')

describe(GoFishGame) do
  let(:game) { GoFishGame.new(deck: TestDeck.new) }
  let(:set) { [PlayingCard.new, PlayingCard.new, PlayingCard.new, PlayingCard.new] }
  let(:game_json) { game.as_json }
  let(:inflated_game) { GoFishGame.from_json(JSON.parse(game_json.to_json)) }

  def create_players(count)
    count.times do |counter|
      game.add_player("Player#{counter}")
    end
    game
  end

  describe('#add_player') do
    it('allows user to join a game') do
      game.add_player('Player1')
      expect(game.players.count).to be(1)
      game.add_player('Player2')
      expect(game.players.count).to be(2)
    end

    it('allows a group of users(array) to join the same game') do
      create_players(4)
      expect(game.players.count).to be(4)
    end
  end

  describe('#distribute_cards_to_players') do
    it('gives the correct number of cards in a 2 player game') do
      create_players(2)
      game.send(:distribute_cards_to_players)
      expect(game.players.map(&:cards_left).all?(7)).to be(true)
    end

    it('gives the correct number of cards in a 4 player game') do
      create_players(4)
      game.send(:distribute_cards_to_players)
      expect(game.players.map(&:cards_left).all?(5)).to be(true)
    end
  end

  describe('#go_to_next_player') do
    it('allows the game to proceed to the next player') do
      expect(game.send(:round)).to be(0)
      game.send(:go_to_next_player)
      expect(game.send(:round)).to be(1)
    end
  end

  describe('#current_player') do
    it('returns the correct current player each round') do
      create_players(2)
      expect(game.current_player.name).to eq('Player0')
      game.send(:go_to_next_player)
      expect(game.current_player.name).to eq('Player1')
    end
  end

  describe('#highest_score_player') do
    it('returns the player with highest points and set to winner') do
      create_players(2)
      game.players[1].add_cards(set)
      game.players[1].check_complete
      expect(game.send(:highest_score_player).name).to_not eq('Player0')
      expect(game.send(:highest_score_player).name).to eq('Player1')
    end
  end

  describe('#any_winner?') do
    it('sets the highest score player to winner.') do
      create_players(2)
      game.players[1].add_cards(set)
      game.players[1].check_complete
      game.any_winner?
      expect(game.winner.name).to_not eq('Player0')
      expect(game.winner.name).to eq('Player1')
    end
  end

  describe('#transfer_cards') do
    it('transfer cards from requested to requester and made a set') do
      create_players(2)
      game.players[1].add_cards(set)
      game.send(:transfer_cards, game.players[1], 'Ace')
      expect(game.last_ten_logs[1]).to match('Player0 completed Ace.')
    end
  end

  describe('#go_fish') do
    it('player takes a card from the deck.') do
      create_players(1)
      game.send(:go_fish, 'Ace')
      expect(game.players[0].cards_left).to be(1)
    end

    it('round remains the same if player fished the requested rank') do
      create_players(2)
      game.send(:go_fish, 'Ace')
      expect(game.current_player.name).to eq('Player0')
    end

    it('round increases if player fished the wrong rank') do
      create_players(2)
      game.send(:go_fish, '2')
      expect(game.current_player.name).to eq('Player1')
    end
  end

  describe('#auto_play') do
    it('picking a random player other than self') do
      create_players(3)
      other_player_names = game.other_players(game.players[0]).map(&:name)
      expect(other_player_names.include?(game.send(:random_player_name))).to be(true)
    end

    it('autoplay to finish the game') do
      create_players(2)
      game.players[1].toggle_autoplay
      game.send(:distribute_cards_to_players)
      game.send(:go_to_next_player)
      expect(game.winner.name).to eq('Player1')
    end
  end

  describe('#last_ten_logs') do
    it('returns the last 10 logs') do
      create_players(2)
      game.players[1].toggle_autoplay
      game.start
      game.send(:go_to_next_player)
      expect(game.last_ten_logs.count > 5).to be(true)
      expect(game.last_ten_logs.include?('Player1 wins the game!')).to be(true)
    end
  end

  describe('#fill_game_with_bots') do
    it('adds a game of bots') do
      game.fill_game_with_bots(5)
      expect(game.players.count).to be(5)
      expect(game.players.all? { |player| player.auto == true }).to be(true)
    end

    it('add 4 bots when there is a player joined') do
      create_players(1)
      game.fill_game_with_bots(5)
      expect(game.players.count).to be(5)
      expect(game.players.count(&:auto)).to be(4)
    end
  end

  describe('#as_json') do
    it('creates a json object') do
      expect(game_json['round']).to eq(0)
      expect(game_json.key?('deck')).to be(true)
    end
  end

  describe('#from_json') do
    it('creates game class from json') do
      expect(inflated_game).to be_instance_of(GoFishGame)
    end

    it('inflated player have the correct attributes') do
      expect(inflated_game.send(:round)).to be(0)
      expect(inflated_game.players.count).to be(0)
      expect(inflated_game.deck).to be_instance_of(CardDeck)
    end
  end
end
