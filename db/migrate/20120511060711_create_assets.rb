class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :data_file_name
      t.string :data_content_type
      t.integer :data_file_size
      t.references :attachable

      t.timestamps
    end
    add_index :assets, :attachable_id
  end
end
