class Transaction < ApplicationRecord
  include Xls

  belongs_to :user
  belongs_to :category
  has_one_attached :receipt
  validates :name, :amount, :category_id, :transaction_date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  attr_accessor :remove_receipt
  before_save :check_remove_receipt
  after_create :send_email

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

  def self.create_from_import(file, current_user)
    transactions = Xls.import(file)
    transactions.each_with_index do |transaction, index|
      next if index.zero?

      category_id = Category.find_by(name: transaction[3])&.id || Category.find_by(name: 'Other')&.id
      begin
        create!(
          name: transaction[0],
          amount: transaction[1],
          description: transaction[2],
          category_id: category_id,
          transaction_date: transaction[4],
          user_id: current_user.id
        )
      rescue => e
        return { error: "Error in row #{index + 1}: #{e.message}" }
      end
    end
  end

  def send_email
    SendTransactionEmailJob.perform_later(id)
  end
end
