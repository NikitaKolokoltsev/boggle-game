class Game < ApplicationRecord
  has_many :game_words
  has_many :words, through: :game_words

  validates_presence_of :board, :duration

  before_create :setup_authentication_token

  def time_left
    time_left = created_at + duration - Time.now
    return 0 if time_left <= 0

    time_left.ceil
  end

  def finished?
    time_left == 0
  end

  private

  def setup_authentication_token
    self.token = JWT.encode({ game_id: id }, Rails.application.secrets.secret_key_base)
  end
end
