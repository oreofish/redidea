class PlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    my_plan_path = ideas_path + "?scope=upload"
    redirect_to my_plan_path
  end

  # upload plan
  def create
    my_plan_path = ideas_path + "?scope=upload"
    @plan = Plan.new(params[:plan].merge(:user_id => current_user.id))

    respond_to do |format|
      if @plan.save
        format.html { redirect_to my_plan_path, :notice => 'plan is successfully uploaded.' }
        format.json { render :json => @idea, :status => :created, :location => @idea }
      else
        format.html { redirect_to my_plan_path, :notice => 'plan was unsuccessfully uploaded.' }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # update plan
  def update
    my_plan_path = ideas_path + "?scope=upload"
    @plan = Plan.find(:first, :conditions => "user_id = #{current_user.id}")

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to my_plan_path, :notice => 'plan is successfully updated.' }
        format.json { render :json => @idea, :status => :created, :location => @idea }
      else
        format.html { redirect_to my_plan_path, :notice => 'plan was unsuccessfully updated.' }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

end
