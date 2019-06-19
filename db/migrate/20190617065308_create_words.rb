class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :value, null: false

      t.timestamp
    end

    add_index :words, :value, unique: true
  end
end
