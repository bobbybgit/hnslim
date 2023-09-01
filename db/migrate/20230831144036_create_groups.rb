class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.boolean :private
      t.string :location
      t.string :description

      t.timestamps
    end
  end
end
