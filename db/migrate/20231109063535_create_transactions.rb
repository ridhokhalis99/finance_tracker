class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.text :name
      t.decimal :amount
      t.references :category, foreign_key: true
      t.text :description
      t.date :transaction_date

      t.timestamps
    end
  end
end
