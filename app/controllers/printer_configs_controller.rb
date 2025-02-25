class PrinterConfigsController < ApplicationController
  before_action :authorize_manager!
  before_action :set_location
  before_action :set_printer_config, only: [:show, :edit, :update, :destroy, :test_print]

  def index
    @printer_configs = @location.printer_configs
  end

  def new
    @printer_config = @location.printer_configs.new
    @available_printers = PrinterConfig.find_available_printers
  end

  def create
    @printer_config = @location.printer_configs.new(printer_config_params)

    if @printer_config.save
      redirect_to location_printer_configs_path(@location), notice: 'Configuracion de impresora craeda correctamente.'
    else
      @available_printers = PrinterConfig.find_available_printers
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_printers = PrinterConfig.find_available_printers
  end

  def update
    if @printer_config.update(printer_config_params)
      redirect_to location_printer_configs_path(@location), notice: 'Configuracion de impresora actualizada correctamente.'
    else
      @available_printers = PrinterConfig.find_available_printers
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @printer_config.destroy
    redirect_to location_printer_configs_path(@location), notice: 'Configuracion de impresora eliminada correctamente.'
  end

  def test_print
    result = @printer_config.test_print

    if result[:success]
      redirect_to location_printer_configs_path(@location), notice: 'Prueba de impresion enviada con exito.'
    else
      redirect_to location_printer_configs_path(@location), alert: "Error al enviar la prueba de impresion: #{result[:message]}"
    end
  end

  private
    def set_location
      @location = Location.find(params[:location_id])

      # Authorization check
      unless current_user.owner? ||
             (current_user.manager? && @location.id == current_user.location)
        redirect_to root_path, alert: 'No tienes permiso para configurar las impresoras de esta sucursal.'
      end
    end

    def set_printer_config
      @printer_config = @location.printer_configs.find(params[:id])
    end

    def printer_config_params
      params.require(:printer_config).permit(:name, :device_id, :printer_type, :active)
    end
end
