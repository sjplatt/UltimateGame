class Fixidfalse < ActiveRecord::Migration
  def change
    add_column :packages, :id, :primary_key
  end
end
