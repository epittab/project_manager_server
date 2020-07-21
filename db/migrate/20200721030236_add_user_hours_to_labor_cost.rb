class AddUserHoursToLaborCost < ActiveRecord::Migration[6.0]
  def change
    add_column :labor_costs, :user_hours, :integer
  end
end
