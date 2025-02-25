class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :print_ticket]

  def index
    if current_user.owner?
      @sales = current_user.organization.sales.order(created_at: :desc).page(params[:page])
    elsif current_user.manager?
      @sales = Sale.where(location_id: current_user.location_id).order(created_at: :desc).page(params[:page])
    else
      @sales = current_user.sales.order(created_at: :desc).page(params[:page])
    end
  end

  def new
    @sale = Sale.new
    @sale.number_of_passengers = 1
  end

  def create
    @sale = current_user.sales.new(sale_params)
    @sale.location_id = current_user.location_id
    @sale.organization_id = current_user.organization_id
    @sale.timestamp = Time.current

    if @sale.save
      redirect_to @sale, notice: 'Venta creada con exito.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def print_ticket
    result = @sale.print_ticket

    if result[:success]
      redirect_to @sale, notice: "Ticket impreso correctament."
    else
      redirect_to @sale, alert: "Error al imprimir el ticket: #{result[:message]}"
    end
  end

  private
    def set_sale
      @sale = Sale.find(params[:id])

      # Authorization check
      unless current_user.owner? ||
             (current_user.manager? && @sale.location_id == current_user.location_id) ||
             @sale.user_id == current_user.id
        redirect_to root_path, alert: "No tienes permisos para acceder a esta venta."
      end
    end

    def sale_params
      params.require(:sale).permit(:amount, :payment_method, :number_of_passengers, :notes)
    end
end
