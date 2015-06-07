class AddMainStoryToGames < ActiveRecord::Migration
  def change
    add_column :games, :hltb, :text
    add_column :games, :MainStory, :integer
    add_column :games, :MainExtra, :integer
    add_column :games, :Completion, :integer
    add_column :games, :Combined, :integer
  end
end
