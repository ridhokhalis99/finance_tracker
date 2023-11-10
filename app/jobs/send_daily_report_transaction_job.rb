require 'sidekiq-scheduler'

class SendDailyReportTransactionJob < ApplicationJob
  queue_as :default

  def perform
    puts 'Sending daily report to all users'
    User.all.each_with_index do |user, index|
        puts "Sending daily report to user #{user.id}"
        TransactionMailer.daily_report(user).deliver_later
    end
  end
end
