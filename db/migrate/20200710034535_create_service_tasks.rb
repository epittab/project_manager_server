class CreateServiceTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :service_tasks do |t|
      t.integer :task_id
      t.float :service_cost
      t.string :service_name
      t.text :service_description

      t.timestamps
    end
  end
end
