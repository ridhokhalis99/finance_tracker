class AddReceiptToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :receipt, :binary
  end
end
