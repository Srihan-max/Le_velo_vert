class CreateVelos < ActiveRecord::Migration[7.0]
  def change
    create_table :velos do |t|
      t.string :nom, null: false
      t.string :type_velo, null: false
      t.text :description, null: false
      t.decimal :tarif_heure, precision: 8, scale: 2, null: false
      t.decimal :tarif_jour, precision: 8, scale: 2, null: false
      t.boolean :disponible, default: true, null: false

      t.timestamps
    end
    
    add_index :velos, :type_velo
    add_index :velos, :disponible
  end
end
