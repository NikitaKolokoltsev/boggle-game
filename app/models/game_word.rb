class GameWord < ApplicationRecord
  belongs_to :game
  belongs_to :word
end
