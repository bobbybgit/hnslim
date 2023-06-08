class AddPlayingTimeToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :playing_time, :integer
  end
end
