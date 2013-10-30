class LicensesControllersController < ApplicationController
  # GET /licenses_controllers
  # GET /licenses_controllers.json
  def index
    @licenses_controllers = LicensesController.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @licenses_controllers }
    end
  end

  # GET /licenses_controllers/1
  # GET /licenses_controllers/1.json
  def show
    @licenses_controller = LicensesController.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @licenses_controller }
    end
  end

  # GET /licenses_controllers/new
  # GET /licenses_controllers/new.json
  def new
    @licenses_controller = LicensesController.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @licenses_controller }
    end
  end

  # GET /licenses_controllers/1/edit
  def edit
    @licenses_controller = LicensesController.find(params[:id])
  end

  # POST /licenses_controllers
  # POST /licenses_controllers.json
  def create
    @licenses_controller = LicensesController.new(params[:licenses_controller])

    respond_to do |format|
      if @licenses_controller.save
        format.html { redirect_to @licenses_controller, notice: 'Licenses controller was successfully created.' }
        format.json { render json: @licenses_controller, status: :created, location: @licenses_controller }
      else
        format.html { render action: "new" }
        format.json { render json: @licenses_controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /licenses_controllers/1
  # PUT /licenses_controllers/1.json
  def update
    @licenses_controller = LicensesController.find(params[:id])

    respond_to do |format|
      if @licenses_controller.update_attributes(params[:licenses_controller])
        format.html { redirect_to @licenses_controller, notice: 'Licenses controller was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @licenses_controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses_controllers/1
  # DELETE /licenses_controllers/1.json
  def destroy
    @licenses_controller = LicensesController.find(params[:id])
    @licenses_controller.destroy

    respond_to do |format|
      format.html { redirect_to licenses_controllers_url }
      format.json { head :no_content }
    end
  end
end
