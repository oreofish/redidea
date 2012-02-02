class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :navigate_bar
  before_filter :authorized_user, :only => :destroy

  # GET /activities
  # GET /activities.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activities }
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    ideas_index
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @activity }
    end
  end

  def my_index
    @activities = Activity.all
    
    respond_to do |format|
      format.html { render :template => "activities/index.html.erb" }
    end
  end
  
  # GET /activities/new
  # GET /activities/new.json
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(params[:activity])

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render json: @activity, status: :created, location: @activity }
      else
        format.html { render action: "new" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.json
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :ok }
    end
  end
  
  private
  def authorized_user
    @activity = current_user.activities.find_by_id(params[:id])
    redirect_to root_path if @activity.nil?
  end
  
  def navigate_bar
    @my_activities = Activity.all
    @activities = Activity.all
  end
  
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
