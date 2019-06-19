class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :board, array: true
      t.integer :duration, default: 0, null: false
      t.string :token
      t.integer :points, default: 0, null: false
      t.timestamps
    end

    add_index :games, :token, unique: true
  end
end
