class AddColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :apps, :text
  end
end
