class AdvisesController < ApplicationController
  # GET /advises
  # GET /advises.json
  def index
    @advise = Advise.new
    @messages = Message.all
    @message = Message.new

    respond_to do |format|
    @advises = Advise.order("created_at DESC")
      format.html # index.html.erb
      format.json { render json: @advises }
    end
  end


  # POST /advises
  # POST /advises.json
  def create
    @advise = Advise.new(params[:advise])

    respond_to do |format|
      if @advise.save
        format.html { redirect_to advises_path, notice: 'Advise was successfully created.'}
        format.json { render json: @advise, status: :created, location: @advise }
        format.js # show.html.erb
      else
        format.html { redirect_to advises_path, notice: 'Failed to create advise.'}
        format.json { render json: @advise.errors, status: :unprocessable_entity }
        format.js # show.html.erb
      end
    end
  end

  # DELETE /advises/1
  # DELETE /advises/1.json
  def destroy
    @advise = Advise.find(params[:id])
    @advise.destroy

    respond_to do |format|
      format.html { redirect_to advises_url }
      format.json { head :ok }
    end
  end
end
