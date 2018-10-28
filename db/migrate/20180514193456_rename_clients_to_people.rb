class RenameClientsToPeople < ActiveRecord::Migration[5.2]
  def change
    rename_table :clients, :people
    rename_column :missions, :client_id, :referent_id
  end
end
