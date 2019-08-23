class JobstatusesController < ApplicationController
  before_action :set_jobstatus, only: [:show, :edit, :update, :destroy]

  # GET /jobstatuses
  # GET /jobstatuses.json
  def index
    @jobstatuses = Jobstatus.all
  end

  # GET /jobstatuses/1
  # GET /jobstatuses/1.json
  def show
  end

  # GET /jobstatuses/new
  def new
    @jobstatus = Jobstatus.new
  end

  # GET /jobstatuses/1/edit
  def edit
  end

  # POST /jobstatuses
  # POST /jobstatuses.json
  def create
    @jobstatus = Jobstatus.new(jobstatus_params)

    respond_to do |format|
      if @jobstatus.save
        format.html { redirect_to @jobstatus, notice: 'Jobstatus was successfully created.' }
        format.json { render :show, status: :created, location: @jobstatus }
      else
        format.html { render :new }
        format.json { render json: @jobstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobstatuses/1
  # PATCH/PUT /jobstatuses/1.json
  def update
    respond_to do |format|
      if @jobstatus.update(jobstatus_params)
        format.html { redirect_to @jobstatus, notice: 'Jobstatus was successfully updated.' }
        format.json { render :show, status: :ok, location: @jobstatus }
      else
        format.html { render :edit }
        format.json { render json: @jobstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobstatuses/1
  # DELETE /jobstatuses/1.json
  def destroy
    @jobstatus.destroy
    respond_to do |format|
      format.html { redirect_to jobstatuses_url, notice: 'Jobstatus was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jobstatus
      @jobstatus = Jobstatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jobstatus_params
      params.require(:jobstatus).permit(:jobID, :status)
    end
end
