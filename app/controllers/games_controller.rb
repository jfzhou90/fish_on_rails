# frozen_string_literal: true

require('./app/models/gofish_game')

class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.pending.find_or_create_by(game_params)
    game.create_gofish_if_possible
    game.start_if_possible(current_user) unless game.users.include?(current_user)
    redirect_to game_path(game)
  end

  def show
    go_fish = Game.get_game(params[:id])
    render :show, locals: { game: go_fish, user: current_user.username, id: params[:id] }
  end

  def update
    game = Game.find(params[:id])
    redirect_to menu_index_path unless game.users.include?(current_user)
    game.play_round(params[:player], params[:rank])
    redirect_to game_path(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:player_count)
  end
end
