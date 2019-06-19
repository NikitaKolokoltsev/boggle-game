class GamesController < ActionController::API
  def show
    game = Game.find(params[:id])

    render json: game, serializer: FullGameInfoSerializer, status: 200
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: 404
  end

  def create
    params_missing = game_params[:duration].blank? || [true, false].exclude?(game_params[:random])
    return render json: { message: "Please provide 'duration' and 'random' options for the game" }, status: 400 if params_missing

    game = Boggle::Game.new(game_params).start.game

    return render json: game, serializer: ShortGameInfoSerializer, status: 201
  end

  def update
    return render json: { message: 'Please provide authentication token for the game.' }, status: 400 if params[:token].blank?

    game = Game.find(params[:id])

    return render json: { message: 'Invalid authentication token.' }, status: 400 if game.token != params[:token]

    Boggle::Game.new.load(game).check_word(params[:word])

    return render json: game, serializer: FullGameInfoSerializer, status: 200

  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: 404
  rescue StandardError => e
    render json: { message: e.message }, status: 400
  end

  private

  def game_params
    params.permit(:board, :random, :duration).to_h.symbolize_keys
  end
end
