class CreateBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :blocks do |t|
      t.integer :project_id
      t.string :block_name
      t.text :block_description

      t.timestamps
    end
  end
end
