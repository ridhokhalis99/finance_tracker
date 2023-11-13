class SendTransactionEmailJob < ApplicationJob
  queue_as :default

  def perform(transaction_id)
    transaction = Transaction.find(transaction_id)
    TransactionMailer.with(transaction: transaction).new_transaction.deliver_now
  end
end
