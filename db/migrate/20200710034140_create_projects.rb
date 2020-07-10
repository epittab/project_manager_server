class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.text :project_description
      t.date :est_start_date
      t.date :est_end_date

      t.timestamps
    end
  end
end
