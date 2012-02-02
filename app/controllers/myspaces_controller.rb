class MyspacesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @my_activities = Activity.all
    @user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @myspace }
    end
  end
  
end
