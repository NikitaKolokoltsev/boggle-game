class ShortGameInfoSerializer < ActiveModel::Serializer
  attributes :id, :token, :duration, :board

  def board
    object.board.flatten.join(', ')
  end
end
