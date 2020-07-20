class CreateServMatCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :serv_mat_costs do |t|
      t.integer :task_id
      t.float :serv_mat_cost
      t.string :serv_mat_name
      t.text :serv_mat_description
      t.timestamps
    end
  end
end
