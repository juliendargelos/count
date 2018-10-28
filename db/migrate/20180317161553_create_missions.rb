class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :uuid, null: false, unique: true, index: true
      t.string :name
      t.date :beginning_date
      t.date :ending_date
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
