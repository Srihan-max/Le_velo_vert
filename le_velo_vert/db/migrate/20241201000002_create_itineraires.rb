class CreateItineraires < ActiveRecord::Migration[7.0]
  def change
    create_table :itineraires do |t|
      t.string :nom, null: false
      t.text :description, null: false
      t.decimal :distance_km, precision: 6, scale: 2, null: false
      t.integer :duree_minutes, null: false
      t.string :niveau, null: false

      t.timestamps
    end
    
    add_index :itineraires, :niveau
  end
end
