class PlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @plan = Plan.find(:all, :conditions => "user_id == #{current_user.id}")[0]
  end

  # upload plan
  def create
    @plan = Plan.new(params[:plan].merge(:user_id => current_user.id))

    respond_to do |format|
      if @plan.save
        format.html { redirect_to ideas_path, :notice => 'plan is successfully uploaded.' }
        format.json { render :json => @idea, :status => :created, :location => @idea }
      else
        format.html { redirect_to ideas_path, :notice => 'plan was unsuccessfully uploaded.' }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

end
