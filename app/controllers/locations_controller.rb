class LocationsController < ApplicationController
  before_action :authorize_manager!, except: [:show]
  before_action :set_location, only: [:show, :edit, :update]
  before_action :authorize_location_access!, only: [:show]

  def index
    @locations = current_user.organization.locations.order(:name)
  end

  def show
    @daily_sales = @location.daily_sales
    @active_users = @location.active_users
  end

  def new
    authorize_owner!
    @location = current_user.organization.locations.new
  end

  def create
    authorize_owner!
    @location = current_user.organization.locations.new(location_params)

    if @location.save
      redirect_to @location, notice: 'Sucursal creada correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_owner!
  end

  def update
    authorize_owner!
    if @location.update(location_params)
      redirect_to @location, notice: 'Sucursal actualizada correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :address, :contact_name, :contact_phone, :active)
    end
end
