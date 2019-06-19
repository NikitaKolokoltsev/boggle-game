class Word < ApplicationRecord
  has_many :game_words
  has_many :games, through: :game_words

  def length
    word.length
  end
end
