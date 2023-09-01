class AddCityToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :city, :string
    add_column :groups, :country, :string
    add_column :groups, :region, :string
    add_column :groups, :latitude, :decimal, precision: 10, scale: 6
    add_column :groups, :longitude, :decimal, precision: 10, scale: 6
    change_column :groups, :description, :text
  end
end
