class CreateTimeTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :time_tasks do |t|
      t.integer :task_id
      t.integer :user_id
      t.string :time_task_name
      t.text :time_task_description

      t.timestamps
    end
  end
end
