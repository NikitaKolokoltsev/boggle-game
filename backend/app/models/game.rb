class Game < ApplicationRecord
  has_many :game_words
  has_many :words, through: :game_words
end
