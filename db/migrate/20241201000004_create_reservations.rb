class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :nom, null: false
      t.string :prenom, null: false
      t.string :email, null: false
      t.string :telephone, null: false
      t.references :velo, null: false, foreign_key: true
      t.date :date_debut, null: false
      t.date :date_fin, null: false
      t.text :commentaire

      t.timestamps
    end
    
    add_index :reservations, :email
    add_index :reservations, :date_debut
    add_index :reservations, :date_fin
  end
end
