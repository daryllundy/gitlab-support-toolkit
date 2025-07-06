class CreateAnalyses < ActiveRecord::Migration[7.0]
  def change
    create_table :analyses do |t|
      t.references :log_file, null: false, foreign_key: true
      t.integer :analysis_type, null: false
      t.integer :status, default: 0, null: false
      t.text :result_summary
      t.json :detailed_results
      t.integer :errors_found, default: 0
      t.integer :warnings_found, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.float :execution_time_seconds

      t.timestamps
    end

    add_index :analyses, :log_file_id
    add_index :analyses, :analysis_type
    add_index :analyses, :status
    add_index :analyses, :created_at
  end
end