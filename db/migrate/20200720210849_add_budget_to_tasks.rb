class AddBudgetToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :budget_amount, :float
  end
end
