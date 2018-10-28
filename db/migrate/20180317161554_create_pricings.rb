class CreatePricings < ActiveRecord::Migration[5.2]
  def change
    create_table :pricings do |t|
      t.string :name
      t.integer :man_day_price_in_cents
      t.references :mission, foreign_key: true

      t.timestamps
    end
  end
end
