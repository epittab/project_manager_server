class AddUserCostToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_cost, :float
  end
end
