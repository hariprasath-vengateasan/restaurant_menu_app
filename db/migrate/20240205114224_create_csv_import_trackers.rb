class CreateCsvImportTrackers < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_import_trackers do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :delayed_job_id
      t.string :status, null: false, default: 'In Progress'
      t.text :error_messages, array: true, default: []

      t.timestamps
    end
  end
end