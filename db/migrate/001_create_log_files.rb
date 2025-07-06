class CreateLogFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :log_files do |t|
      t.string :name, null: false
      t.string :file_path, null: false
      t.integer :file_size, null: false
      t.integer :status, default: 0, null: false
      t.text :description
      t.json :metadata
      t.datetime :uploaded_at

      t.timestamps
    end

    add_index :log_files, :status
    add_index :log_files, :created_at
  end
end