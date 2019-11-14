class RemoveInvoiceNumberFromMissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :missions, :invoice_number, :string
  end
end
