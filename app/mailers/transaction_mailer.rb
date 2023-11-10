class TransactionMailer < ApplicationMailer
  include Xls
  def daily_report (user)
    transactions = Transaction.where(user_id: user.id, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
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
    attachments["daily_report.xls"] = xls
    @user = user
    mail(to: user.email, subject: 'Daily Report')
  end
end
