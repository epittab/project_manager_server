class AddStatusToBlocks < ActiveRecord::Migration[6.0]
  def change
    add_column :blocks, :status_id, :integer
  end
end
