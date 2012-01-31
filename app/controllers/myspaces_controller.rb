class MyspacesController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    ideas_index
    @activities = Activity.all
    @user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @myspace }
    end
  end
  
  private
  
  def ideas_index
    @idea = Idea.new
    @ideas = Array.new
    @liked_ideas = Array.new
    @plans = current_user.plans

    @scope = params[:scope] || 'liked'
    @scopes = [:liked, :mine, :upload, :rule]

    if @scope == "mine" 
      @ideas = current_user.ideas
      @ideas.reverse!
    elsif @scope == "liked" 
      @liked_ideas = current_user.liking
      @ideas = Idea.all - @liked_ideas - current_user.ideas
      @liked_ideas.reverse!
    elsif @scope == "upload"
      @plan = Plan.find(:first, :conditions => "user_id = #{current_user.id}")
      if not @plan
        @plan = Plan.new
      end 
    end
  end

end
