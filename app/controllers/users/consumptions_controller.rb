class Users::ConsumptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate
  before_action :set_consumption, only: %i[ show edit update destroy ]
  before_action :set_consumptions, only: :index

  # GET /consumptions or /consumptions.json
  def index
    @energy_options ||= Consumption.energy_options


    @total_consumption = @consumptions.sum(:value).to_f
    @average_daily_consumption = Consumption.average_daily_consumption(@consumptions).to_f
    @monthly_peak_consumption = Consumption.monthly_peak_consumption(@consumptions)
    @monthly_total_consumption = Consumption.monthly_total_consumption(@consumptions)
    @unit = @consumptions.first&.unit
  end

  # GET /consumptions/1 or /consumptions/1.json
  def show
  end

  # GET /consumptions/new
  def new
    @consumption = Current.user.consumptions.build
  end

  # GET /consumptions/1/edit
  def edit
  end

  # POST /consumptions or /consumptions.json
  def create
    @consumption = Current.user.consumptions.build(consumption_params)

    respond_to do |format|
      if @consumption.save
        format.html { redirect_to @consumption, notice: "Consumption was successfully created." }
        format.json { render :show, status: :created, location: @consumption }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumptions/1 or /consumptions/1.json
  def update
    respond_to do |format|
      if @consumption.update(consumption_params)
        format.html { redirect_to @consumption, notice: "Consumption was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @consumption }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumptions/1 or /consumptions/1.json
  def destroy
    @consumption.destroy!

    respond_to do |format|
      format.html { redirect_to consumptions_path, notice: "Consumption was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumption
      @consumption = Current.user.consumptions.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def consumption_params
      params.expect(consumption: [ :energy_type, :value, :unit, :measured_at ])
    end

    def authenticate
      Current.user = current_user
    end

    def set_consumptions
      @q = Current.user.consumptions.ransack(params[:q] || { energy_type_eq: 0 })
      @consumptions = @q.result(distinct: true)
    end
end
