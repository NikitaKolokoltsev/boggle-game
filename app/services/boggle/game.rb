module Boggle
  class Game
    class Error < StandardError; end

    class MissingWordFromDictionary < Error
      def message
        'Dictionary does not contain this word.'
      end
    end

    class MissingWordFromBoard < Error
      def message
        'This word cannot be derived from the current board.'
      end
    end

    class WordAlreadyUsed < Error
      def message
        'This word was already used in this game.'
      end
    end

    class WordFormatMismatch < Error
      def message
        'Word must consist only of letters A-Z'
      end
    end

    class GameFinished < Error
      def message
        'This game is already finished.'
      end
    end

    ADJACENT_CELLS_SHIFTS = [
      [-1, -1], # DIAGONAL TOP LEFT
      [-1, 0],  # TOP
      [-1, 1],  # DIAGONAL TOP RIGHT
      [0, -1],  # LEFT
      [0, 1],   # RIGHT
      [1, -1],  # DIAGONAL BOTTOM LEFT
      [1, 0],   # BOTTOM
      [1, 1]    # DIAGONAL BOTTOM RIGHT
    ].freeze

    attr_reader :board, :game, :duration

    def initialize(board: Board.default.flatten, random: false, duration: nil)
      @board = random ? Board.random : Board.create(board)
      @duration = duration
      @game = ::Game.new(board: @board.flatten, duration: @duration)
    end

    def start
      @game.save
      self
    end

    def load(game)
      @game = game
      @duration = game.duration
      @board = Board.to_matrix(game.board)
      self
    end

    def check_word(word)
      raise GameFinished if game.finished?
      raise WordFormatMismatch unless word.match(::Word::WORD_REGEX).present?
      raise MissingWordFromBoard unless is_word_on_board?(word.upcase)

      word = Word.find_by(value: word.downcase)
      raise MissingWordFromDictionary unless word.present?

      word_used = @game.words.find_by(id: word.id).present?
      raise WordAlreadyUsed if word_used

      @game.words << word
      @game.points += word.length
      @game.save

      @game
    end

    def is_word_on_board?(word)
      letters = word.split('')
      word_found = false

      @board.each_with_index do |_, row|
        @board[row].each_with_index do |letter, col|
          next if letter != letters[0] && letter != '*'

          visited = [[row, col]]

          word_found = bfs(row, col, letters[1..-1], visited)

          break if word_found
        end

        break if word_found
      end

      word_found
    end

    def bfs(row, col, letters, visited)
      return true if letters.empty?

      result = false

      unvisited_adjacent_cells = adjacent_cells(row, col) - visited

      unvisited_adjacent_cells.each do |cell|
        cell_row = cell[0]
        cell_col = cell[1]
        letter = @board[cell_row][cell_col]

        next if letter != letters[0] && letter != '*'
        visited += [[cell_row, cell_col]]

        result = bfs(cell_row, cell_col, letters[1..-1], visited)

        break if result
      end

      result
    end

    def adjacent_cells(row, col)
      adjacent_cells = []

      ADJACENT_CELLS_SHIFTS.each do |cell|
        adjacent_cell_row = row + cell[0]
        adjacent_cell_col = col + cell[1]

        next if adjacent_cell_col < 0 || adjacent_cell_row < 0 ||
                adjacent_cell_row >= @board.size || adjacent_cell_col >= @board.size

        adjacent_cells.push([adjacent_cell_row, adjacent_cell_col])
      end

      adjacent_cells
    end
  end
end
