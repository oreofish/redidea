class MessagesController < ApplicationController
  def index
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
  end

  def create
    @message = Message.create!(params[:message])
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      redirect_to @message, :notice  => "Successfully updated message."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_url, :notice => "Successfully destroyed message."
  end
end
