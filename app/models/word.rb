class Word < ApplicationRecord
  WORD_REGEX = /\A[a-z]*\z/i

  has_many :game_words
  has_many :games, through: :game_words

  validates :value, presence: true, uniqueness: true,
                    format: { with: WORD_REGEX,  message: 'must consist only of letters A-Z' }

  def length
    value.length
  end
end
