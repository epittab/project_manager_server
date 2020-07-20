class DropTableServiceTasks < ActiveRecord::Migration[6.0]
  def change
    drop_table :service_tasks
  end
end
