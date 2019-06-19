module Boggle
  class Board
    BOARD_SIZE = 4
    LETTERS = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z *]

    def self.create(board)
      board.is_a?(Array) ? to_matrix(board) : to_matrix(board.split(', '))
    end

    def self.random
      fields_count = BOARD_SIZE ** 2
      board = fields_count.times.map { LETTERS.sample }
      to_matrix(board)
    end

    def self.default
      board = File.open(Rails.root.join(ENV['DEFAULT_BOARD_PATH'])).first.strip.split(', ')
      to_matrix(board)
    end

    def self.to_matrix(board)
      board.each_slice(BOARD_SIZE).to_a
    end
  end
end
