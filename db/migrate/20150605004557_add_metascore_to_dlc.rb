class AddMetascoreToDlc < ActiveRecord::Migration
  def change
    add_column :dlcs, :hltb, :text
    add_column :dlcs, :MainStory, :integer
    add_column :dlcs, :MainExtra, :integer
    add_column :dlcs, :Completion, :integer
    add_column :dlcs, :Combined, :integer
  end
end
