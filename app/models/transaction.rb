class Transaction < ApplicationRecord
  include Xls

  belongs_to :user
  belongs_to :category
  has_one_attached :receipt
  validates :name, :amount, :category_id, :transaction_date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  attr_accessor :remove_receipt
  before_save :check_remove_receipt

  def check_remove_receipt
    puts "remove_receipt: #{remove_receipt}"
    receipt.purge if remove_receipt == '1'
  end

  def self.generate_xls(transactions)
    xls_rows = transactions.map do |transaction|
      category_name = Category.find(transaction.category_id).name
      [
        transaction.name,
        transaction.amount,
        transaction.description,
        category_name,
        transaction.transaction_date
      ]
    end
    headers = ['Name', 'Amount', 'Description', 'Category', 'Transaction Date']
    xls = Xls.export(headers, xls_rows)
  end
end
