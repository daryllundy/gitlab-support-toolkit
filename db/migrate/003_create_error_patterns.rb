class CreateErrorPatterns < ActiveRecord::Migration[7.0]
  def change
    create_table :error_patterns do |t|
      t.references :analysis, null: false, foreign_key: true
      t.string :pattern, null: false
      t.integer :pattern_type, null: false
      t.integer :severity, null: false
      t.text :description
      t.json :match_data
      t.integer :match_count, default: 0
      t.text :sample_matches
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :error_patterns, :analysis_id
    add_index :error_patterns, :pattern_type
    add_index :error_patterns, :severity
    add_index :error_patterns, :is_active
  end
end