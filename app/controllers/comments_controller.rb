class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy
  
  # GET /comments
  # GET /comments.json
  def index
    @idea = Idea.find(params[:idea_id])
    @comment = Comment.new(:commentable_id => @idea.id)
    @comments = @idea.comments
    respond_to do |format|
      format.js 
      format.json { render json: @comments }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @idea = Idea.find(params[:comment][:commentable_id])
    @comment = @idea.comments.create(:comment => params[:comment][:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        @comments = @idea.comments
        @comment = Comment.new(:commentable_id => @idea.id)
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js { render "index" }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { redirect_to ideas_path+"?scope=liked" }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @idea = @comment.commentable
    @comment.destroy
    @comments = @idea.comments
    @comment = Comment.new(:commentable_id => @idea.id)

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.js { render "index" }
    end
  end

  private
    def authorized_user
      comment = Comment.find(params[:id])
      redirect_to root_path if comment.user != current_user
    end
end
