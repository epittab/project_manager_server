class AddStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status_id, :integer
  end
end
