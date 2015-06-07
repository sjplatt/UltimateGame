class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :steamid
      t.references :game, index: true

      t.timestamps null: false
    end
    add_foreign_key :packages, :games
  end
end