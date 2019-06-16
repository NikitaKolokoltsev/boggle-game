class CreateGameWords < ActiveRecord::Migration[5.2]
  def change
    create_table :game_words do |t|
      t.belongs_to :game
      t.belongs_to :word
    end
  end
end
