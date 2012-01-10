class UserMailer < ActionMailer::Base
  default from: "jianxing@redflag-linux.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify.subject
  #
  def notify(user)
    @user = user
    @new_ideas = Idea.all - @user.liking - @user.ideas
    @link = default_url_options[:host]
    if @user.confirmation_token
      @link += "/users/confirmation?confirmation_token=#{@user.confirmation_token}" 
    end
    
    if @new_ideas.count > 3
      mail to: @user.email, subject: t(:notify_subject)
    end
  end
end
