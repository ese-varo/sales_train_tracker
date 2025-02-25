class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :payment_method
      t.integer :number_of_passengers
      t.text :notes
      t.datetime :timestamp
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sales, :timestamp
  end
end
