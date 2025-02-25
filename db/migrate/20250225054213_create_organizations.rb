class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :tax_id
      t.string :contact_email
      t.string :contact_phone
      t.text :address
      t.boolean :active, default: true
      t.string :timezone

      t.timestamps
    end
  end
end
