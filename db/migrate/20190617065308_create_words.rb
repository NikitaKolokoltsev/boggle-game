class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :word

      t.timestamp
    end

    add_index :words, :word
  end
end
