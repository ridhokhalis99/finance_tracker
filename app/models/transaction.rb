class Transaction < ApplicationRecord
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
end
