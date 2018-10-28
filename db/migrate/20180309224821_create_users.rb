class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :email, null: false, default: '', index: true, unique: true
      t.string :password_digest, null: false, default: ''
      t.string :phone, null: false, default: ''

      t.timestamps null: false
    end
  end
end
