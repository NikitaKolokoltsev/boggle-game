class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: 404
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { message: e.message.capitalize }, status: 400
  end

  rescue_from Boggle::Game::Error do |e|
    render json: { message: e.message }, status: 400
  end
end
