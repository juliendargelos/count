class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :country
      t.string :city
      t.string :zipcode
      t.string :address
      t.string :company

      t.timestamps
    end
  end
end
