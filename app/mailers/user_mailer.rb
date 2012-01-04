class UserMailer < ActionMailer::Base
  default from: "jianxing@redflag-linux.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify.subject
  #
  def notify(emails)
    mail to: emails, subject: "Notify"
  end
end
