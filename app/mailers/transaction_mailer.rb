class TransactionMailer < ApplicationMailer
  include Xls

  def daily_report (user)
    transactions = Transaction.where(user_id: user.id, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    return if transactions.empty?
    xls = Transaction.generate_xls(transactions)
    attachments["daily_report_#{Time.zone.now.strftime('%Y_%m_%d')}.xls"] = xls
    @user = user
    mail(to: user.email, subject: "Daily report #{Time.zone.now.strftime('%d-%m-%Y')}")
  end

  def new_transaction
    @transaction = params[:transaction]
    @user = @transaction.user
    mail(to: @user.email, subject: "Transaction #{@transaction.name} has been created")
  end
end
