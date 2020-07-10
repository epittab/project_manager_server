class CreateMaterialTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :material_tasks do |t|
      t.integer :task_id
      t.float :material_cost
      t.string :material_name
      t.text :material_description

      t.timestamps
    end
  end
end
