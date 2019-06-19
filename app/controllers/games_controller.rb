class GamesController < ApplicationController
  before_action :validate_update_params, only: [:update]

  def show
    game = Game.find(params[:id])

    render json: game, serializer: FullGameInfoSerializer, status: 200
  end

  def create
    new_game_params = game_params.to_h.symbolize_keys
    game = Boggle::Game.new(new_game_params).start.game

    render json: game, serializer: ShortGameInfoSerializer, status: 201
  end

  def update
    game = Game.find_by!(id: params[:id], token: params[:token])

    Boggle::Game.new.load(game).check_word(params[:word])

    render json: game, serializer: FullGameInfoSerializer, status: 200
  end

  private

  def game_params
    params.require(%i[duration random])
    params.permit(:board, :random, :duration)
  end

  def validate_update_params
    params.require(%i[token word])
  end
end
