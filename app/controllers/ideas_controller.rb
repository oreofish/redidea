class IdeasController < ApplicationController
  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.all
    @idea = Idea.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ideas }
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(params[:idea])

    respond_to do |format|
      if @idea.save
        format.html { redirect_to ideas_path, :notice => 'Idea was successfully created.' }
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
end
