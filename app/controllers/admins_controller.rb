class AdminsController < ApplicationController
  before_filter :authenticate_user!
	
	# POST /ranks
	def admin
      @messages = Message.all
      @message = Message.new
      
      if can? :rank, Idea
        @scope = params[:scope] || 'rank'
        @scopes= [:rank, :email]
        if @scope == "rank"
          @ideas = Idea.find_by_sql("SELECT ideas.*,SUM(likes.score) AS scores,COUNT(likes.idea_id) AS counts From ideas,likes WHERE likes.idea_id=ideas.id GROUP BY likes.idea_id ORDER BY scores DESC")
        end

    	respond_to do |format|
          format.html # index.html.erb
          format.js
    	end
      else 
        redirect_to ideas_path
      end
	end
    
    def invite
      emails = params[:invite].split("\n")
      if emails.count == 1 and emails[0] == 'all'
        users = User.find(:all)
        users.each do |user|
          UserMailer.notify(user).deliver
        end
        render :text => users.count
        return
      end
      
      emails.each do |email|
        email.strip!
        user = User.find_by_email(email)
        if user
          # registered user
          UserMailer.notify(user).deliver
        else
          # non registered user
          password = "abc123"
          User.create!(:email => email, :password => password,
                       :password_confirmation => password)
        end
      end
      render :text => emails
    end
  end
