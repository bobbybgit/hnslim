class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :min_players
      t.integer :max_players
      t.integer :min_rec_players
      t.integer :max_rec_players
      t.float :weight
      t.string :image
      t.integer :bgg_id
      t.text :description

      t.timestamps
    end
  end
end
