class CreateActualites < ActiveRecord::Migration[7.0]
  def change
    create_table :actualites do |t|
      t.string :titre, null: false
      t.text :contenu, null: false
      t.date :date_publication, null: false

      t.timestamps
    end
    
    add_index :actualites, :date_publication
  end
end
