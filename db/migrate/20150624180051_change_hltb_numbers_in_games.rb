class ChangeHltbNumbersInGames < ActiveRecord::Migration
  def up
    change_column :games, :MainStory, :real
    change_column :games, :MainExtra, :real
    change_column :games, :Completion, :real
    change_column :games, :Combined, :real
    change_column :dlcs, :MainStory, :real
    change_column :dlcs, :MainExtra, :real
    change_column :dlcs, :Completion, :real
    change_column :dlcs, :Combined, :real
  end
  def down
    change_column :games, :MainStory, :integer
    change_column :games, :MainExtra, :integer
    change_column :games, :Completion, :integer
    change_column :games, :Combined, :integer
    change_column :dlcs, :MainStory, :integer
    change_column :dlcs, :MainExtra, :integer
    change_column :dlcs, :Completion, :integer
    change_column :dlcs, :Combined, :integer
  end
end
