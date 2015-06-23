class AddItadToGames < ActiveRecord::Migration
  def change
    add_column :games, :itad, :string
    add_column :dlcs, :itad, :string
    add_column :packages, :itad, :string
  end
end
