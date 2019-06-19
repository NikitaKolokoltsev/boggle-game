class FullGameInfoSerializer < ActiveModel::Serializer
  attributes :id, :token, :duration, :board, :time_left, :points

  def board
    object.board.flatten.join(', ')
  end
end
