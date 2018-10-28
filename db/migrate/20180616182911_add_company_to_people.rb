class AddCompanyToPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :company, :string
    add_reference :people, :company, foreign_key: true
  end
end
