class AddMetascoreToGames < ActiveRecord::Migration
  def change
    add_column :games, :metascore, :integer
    add_column :dlcs, :metascore, :integer
    add_column :games, :metaurl, :text
    add_column :dlcs, :metaurl, :text
  end
end
