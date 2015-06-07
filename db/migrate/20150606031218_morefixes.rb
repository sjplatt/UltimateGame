class Morefixes < ActiveRecord::Migration
  def change
    remove_column :packages, :developer
    remove_column :packages, :recommendations
    remove_column :packages, :legal
    remove_column :packages, :review
  end
end
