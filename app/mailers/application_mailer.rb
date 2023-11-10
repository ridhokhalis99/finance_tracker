class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.email_username
  layout 'mailer'
end
