class CreateDlcs < ActiveRecord::Migration
  def change
    create_table :dlcs do |t|
      t.string :name
      t.integer :steamid
      t.references :game, index: true

      t.timestamps null: false
    end
    add_foreign_key :dlcs, :games
  end
end
