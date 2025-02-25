class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :ticket_number
      t.datetime :valid_until
      t.references :sale, null: false, foreign_key: true
      t.integer :template_id
      t.boolean :printed

      t.timestamps
    end
  end
end
