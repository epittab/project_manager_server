class AddIsServiceToServMatCost < ActiveRecord::Migration[6.0]
  def change
    add_column :serv_mat_costs, :isService, :boolean
  end
end
