class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :board, array: true
      t.integer :duration
      t.string :token
      t.integer :points, default: 0
      t.timestamps
    end
  end
end
