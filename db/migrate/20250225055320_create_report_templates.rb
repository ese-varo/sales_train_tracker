class CreateReportTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :report_templates do |t|
      t.string :name
      t.text :description
      t.text :template_data
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
