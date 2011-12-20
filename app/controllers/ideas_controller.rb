class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy


  # GET /ideas
  # GET /ideas.json
  def index
    if params[:scope] == "mine" 
      @ideas = current_user.ideas
      @scope = :mine
    else 
      @ideas = Idea.find(:all, :conditions => "user_id != #{current_user.id}")
      @scope = :all
    end

    @idea = Idea.new
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ideas }
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea  = current_user.ideas.build(params[:idea])

    respond_to do |format|
      if @idea.save
        format.html { redirect_to ideas_path, :notice => t(:idea_successfully_created) }
        format.json { render :json => @idea, :status => :created, :location => @idea }
      else
        format.html { redirect_to ideas_path, :notice => 'Idea was unsuccessfully created.' }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :ok }
    end
  end

  private
    def authorized_user
      @idea = current_user.ideas.find_by_id(params[:id])
      redirect_to root_path if @idea.nil?
    end
end
