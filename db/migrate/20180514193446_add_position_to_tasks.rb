class AddPositionToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :position, :integer
    add_index :tasks, [:position, :mission_id], unique: true
  end
end
