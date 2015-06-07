class AddColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :subreddit, :text
    add_column :games, :wikipedia, :text
    add_column :games, :steampercent, :integer
  end
end
