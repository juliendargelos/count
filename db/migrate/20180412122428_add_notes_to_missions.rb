class AddNotesToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :notes, :text
  end
end
