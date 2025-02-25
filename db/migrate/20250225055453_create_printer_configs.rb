class CreatePrinterConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :printer_configs do |t|
      t.string :name
      t.string :device_id
      t.string :printer_type
      t.references :location, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
