class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :block_id
      t.string :task_name
      t.text :task_description
      t.date :est_start_date
      t.date :est_end_date
      t.date :act_start_date
      t.date :act_end_date

      t.timestamps
    end
  end
end
