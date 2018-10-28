class CreateReferentials < ActiveRecord::Migration[5.2]
  def change
    create_table :referentials do |t|
      t.integer :man_day_duration_in_seconds
      t.integer :work_per_day_duration_in_seconds
      t.references :mission, foreign_key: true

      t.timestamps
    end
  end
end
