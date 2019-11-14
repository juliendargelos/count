class AddInvoiceNumberToMission < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :invoice_number, :integer, null: false
  end
end
