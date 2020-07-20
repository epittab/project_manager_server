class DropMaterialTasks < ActiveRecord::Migration[6.0]
  def change
    drop_table :material_tasks
  end
end
