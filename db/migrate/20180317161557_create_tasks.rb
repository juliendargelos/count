class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :difficulty
      t.integer :minimum_duration_in_seconds
      t.integer :maximum_duration_in_seconds
      t.references :mission, foreign_key: true
      t.references :pricing, foreign_key: true

      t.timestamps
    end
  end
end
