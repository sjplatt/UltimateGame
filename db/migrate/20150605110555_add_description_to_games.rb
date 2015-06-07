class AddDescriptionToGames < ActiveRecord::Migration
  def change
    add_column :games, :description, :text
    add_column :games, :website, :text
    add_column :games, :review, :text
    add_column :games, :minreq, :text
    add_column :games, :recreq, :text
    add_column :games, :releasedate, :text
    add_column :games, :developer, :text
    add_column :games, :headerimg, :text
    add_column :games, :recommendations, :integer
    add_column :games, :legal, :text

    add_column :dlcs, :description, :text
    add_column :dlcs, :website, :text
    add_column :dlcs, :review, :text
    add_column :dlcs, :minreq, :text
    add_column :dlcs, :recreq, :text
    add_column :dlcs, :releasedate, :text
    add_column :dlcs, :developer, :text
    add_column :dlcs, :headerimg, :text
    add_column :dlcs, :recommendations, :integer
    add_column :dlcs, :legal, :text

    add_column :packages, :metascore, :integer
    add_column :packages, :metaurl, :text
    add_column :packages, :hltb, :text
    add_column :packages, :MainStory, :integer
    add_column :packages, :MainExtra, :integer
    add_column :packages, :Completion, :integer
    add_column :packages, :Combined, :integer
    add_column :packages, :description, :text
    add_column :packages, :website, :text
    add_column :packages, :review, :text
    add_column :packages, :minreq, :text
    add_column :packages, :recreq, :text
    add_column :packages, :releasedate, :text
    add_column :packages, :developer, :text
    add_column :packages, :headerimg, :text
    add_column :packages, :recommendations, :integer
    add_column :packages, :legal, :text

    remove_column :games, :hltbid
  end
end
