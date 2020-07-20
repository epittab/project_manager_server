class DropTableTimeTasks < ActiveRecord::Migration[6.0]
  def change
    drop_table :time_tasks
  end
end
