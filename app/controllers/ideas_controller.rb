class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy


  # GET /ideas
  # GET /ideas.json
  def index
    @idea = Idea.new
    @ideas = Array.new
    @liked_ideas = Array.new

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

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea  = current_user.ideas.build(params[:idea])
    mypath = ideas_path + "?scope=mine"

    respond_to do |format|
      if @idea.save
        @scope = 'mine'
        @ideas = current_user.ideas
        @ideas.reverse!

        format.html { redirect_to mypath, :notice => t(:idea_successfully_created) }
        format.json { render :json => @idea, :status => :created, :location => @idea }
        format.js 
      else
        format.html { redirect_to mypath, :notice => t(:idea_was_unsuccessfully_created) }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
    mypath= ideas_path + "?scope=mine"

    respond_to do |format|
      format.html { redirect_to mypath }
      format.json { head :ok }
      format.js
    end
  end

  private
    def authorized_user
      @idea = current_user.ideas.find_by_id(params[:id])
      redirect_to root_path if @idea.nil?
    end
end
