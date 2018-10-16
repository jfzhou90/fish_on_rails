# frozen_string_literal: true

require_relative('./deck')
require_relative('./player')

class GoFishGame # rubocop:disable Metrics/ClassLength
  attr_reader :deck, :players, :winner, :game_id, :started, :player_count

  def initialize(players: [], deck: CardDeck.new, round: 0, logs: [])
    @deck = deck
    @players = players
    @round = round
    @logs = logs
    @winner = nil
  end

  def start
    distribute_cards_to_players
    add_log('Game started!')
  end

  def add_player(username)
    players.push(Player.new(name: username))
  end

  def current_player
    return nil if winner || players.count.zero?

    players[round % players.count]
  end

  def any_winner?
    players.any?(&:empty?) ? self.winner = highest_score_player : false
    deck.empty? ? self.winner = highest_score_player : false
    add_log("#{winner.name} wins the game!") if winner
  end

  def play_round(player_name, rank)
    player = find_player(player_name)
    player.any_rank?(rank) ? transfer_cards(player, rank) : go_fish(rank)
    any_winner?
  end

  def other_players(current_user)
    players.reject { |player| player.name == current_user.name }
  end

  def find_player(name)
    players.find { |player| player.name.casecmp(name).zero? }
  end

  def last_ten_logs
    logs.last(10)
  end

  def fill_game_with_bots(desired_player_count)
    bot_count = desired_player_count - players.count
    bot_count.times do |count|
      bot = Player.new(name: "FisherBot#{count + 1}")
      bot.toggle_autoplay
      players.push(bot)
    end
    start
  end

  def auto_play
    return if winner

    play_round(random_player_name, random_rank) while !current_player.nil? && current_player.auto
  end

  def as_json
    {
      'deck' => deck.as_json,
      'players' => players.map(&:as_json),
      'round' => round,
      'logs' => logs,
      'winner' => winner
    }
  end

  def self.from_json(game_json)
    GoFishGame.new(
      deck: CardDeck.from_json(game_json['deck']),
      players: game_json['players'].map { |player| Player.from_json(player) },
      round: game_json['round'],
      logs: game_json['logs'],
      winner: game_json['winner']
    )
  end

  private

  attr_reader :logs
  attr_accessor :round
  attr_writer :winner, :started

  def go_to_next_player
    self.round = round + 1
    auto_play if current_player
  end

  def distribute_cards_to_players
    deck.shuffle
    init_cards_count = players.count > 3 ? 5 : 7
    init_cards_count.times do
      players.each { |player| player.add_cards(deck.deal) }
    end
  end

  def highest_score_player
    players.max_by(&:points)
  end

  def add_log(message)
    logs.push(message)
  end

  def transfer_cards(player, rank)
    current_player.add_cards(player.give(rank))
    add_log("#{current_player.name} took #{rank}s from #{player.name}.")
    completion_message(rank)
  end

  def go_fish(rank)
    return if deck.empty?

    card = deck.deal
    current_player.add_cards(card)
    add_log("#{current_player.name} fished a card.")
    completion_message(rank)
    go_to_next_player unless card.rank.casecmp(rank).zero?
  end

  def completion_message(rank)
    add_log("#{current_player.name} completed #{rank}.") if current_player.check_complete
  end

  def random_player_name
    random_index = rand(0...players.count - 1)
    other_players(current_player)[random_index].name
  end

  def random_rank
    current_player.pick_random_rank
  end
end
