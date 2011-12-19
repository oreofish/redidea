class LikesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user

  # POST /likes 
  def create
    @like = current_user.like!(params[:like])
    respond_to do |format|
      if @like.save
        format.html { redirect_to ideas_path, :notice => 'Like was successfully created.' }
        format.json { render :json => @like, :status => :created, :location => @like }
      else
        format.html { redirect_to ideas_path, :notice => 'Like was unsuccessfully created.' }
        format.json { render :json => @like.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def authorized_user
      if (not params.empty?) and params.has_key?(:like) and params[:like].has_key?(:idea_id) and params[:like].has_key?(:score)
        # 检测传入的like是否是自己的idea 
        # 检测传入的like是否已经被创建
        if current_user.ideas.find_by_id(params[:like][:idea_id]) or current_user.liking?(params[:like][:idea_id])
          redirect_to root_path 
        end

      else
        redirect_to root_path
      end
    end
end
