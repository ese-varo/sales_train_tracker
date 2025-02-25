class ReportsController < ApplicationController
  before_action :authorize_manager!

  def index
    # Dashboard with report options
  end

  def daily
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    if current_user.owner?
      @locations = current_user.organization.locations.where(active: true)
      @sales = current_user.organization.sales.where(timestamp: @date.beginning_of_day..@date.end_of_day)
    else
      @locations = [current_user.location]
      @sales = Sale.where(location_id: current_user.location_id, timestamp: @date.beginning_of_day..@date.end_of_day)
    end

    @total_amount = @sales.sum(:amount)
    @total_passengers = @sales.sum(:number_of_passengers)
    @sales_by_payment_method = @sales.group(:payment_method).count
    @sales_by_hour = @sales.group_by_hour(:timestamp).count
  end

  def monthly
    @year = params[:year] ? params[:year].to_i : Date.today.year
    @month = params[:month] ? params[:month].to_i : Date.today.month

    @start_date = Date.new(@year, @month, 1).beginning_of_day
    @end_date = @start_date.end_of_month.end_of_day

    if current_user.owner?
      @data = current_user.organization.monthly_report(@year, @month)
    else
      @sales = Sale.where(location_id: current_user.location_id, timestamp: @start_date..@end_date)
      @data = {
        total_sales: @sales.sum(:amount),
        total_passengers: @sales.sum(:number_of_passengers),
        sales_by_user: User.joins(:sales)
          .where(sales: { timestamp: @start_date..@end_date, location_id: current_user.location_id })
          .group('users.id')
          .select('users.name, COUNT(sales.id) as count, SUM(sales.amount) as total_amount')
      }
    end
  end

  def export
    authorize_owner!

    @start_date = params[:start_date] ? Date.parse(params[:start_date]).beginning_of_day : 30.days.ago.beginning_of_day
    @end_date = params[:end_date] ? Date.parse(params[:end_date]).end_of_day : Date.today.end_of_day

    @sales = current_user.organization.sales.where(timestamp: @start_date..@end_date)

    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv(@sales),
          filename: "reporte-de-ventas-#{@start_date.to_date}-a-#{@end_date.to_date}.csv"
      end
    end
  end

  private
    def generate_csv(sales)
      require 'csv'

      CSV.generate(headers: true) do |csv|
        csv << ["Fecha", "Hora", "Sucursal", "Cajero", "Monto", "Metodo de pago", "Pasajeros", "Numero de Boleto"]

        sales.includes(:user, :location, :ticket).each do |sale|
          csv << [
            sale.timestamp.to_date,
            sale.timestamp.strftime("%H:%M"),
            sale.location.name,
            sale.user.name,
            sale.amount,
            sale.payment_method,
            sale.number_of_passengers,
            sale.ticket&.ticket_number
          ]
        end
      end
    end
end
