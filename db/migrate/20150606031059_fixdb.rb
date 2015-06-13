class Fixdb < ActiveRecord::Migration
  def change
    remove_column :packages, :description
    remove_column :packages, :website
    remove_column :packages, :steamid
    remove_column :packages, :metascore
    remove_column :packages, :metaurl
    remove_column :packages, :hltb
    remove_column :packages, :MainStory
    remove_column :packages, :MainExtra
    remove_column :packages, :Completion
    remove_column :packages, :Combined
    remove_column :packages, :minreq
    remove_column :packages, :recreq
    remove_column :packages, :recommendations
    add_column :packages, :packageid, :integer
  end
end
