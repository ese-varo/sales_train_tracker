class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :address
      t.string :contact_name
      t.string :contact_phone
      t.boolean :active
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
