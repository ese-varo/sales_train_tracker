class Organization < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :sales, through: :locations

  validates :name, presence: true, uniqueness: true

  def total_sales(start_date = nil, end_date = nil)
    scope = sales
    scope = scope.where(timestamp: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def active_locations
    locations.where(active: true)
  end

  def sales_by_location(start_date = nil, end_date = nil)
    query = locations.includes(:sales)

    if start_date && end_date
      query = query.where(sales: { timestamp: start_date..end_date })
    end

    query.group('locations.id')
         .select('locations.name, SUM(sales.amount) as total_amount')
  end

  def monthly_report(year = Date.today.year, month = Date.today.month)
    start_date = Date.new(year, month, 1).beginning_of_day
    end_date = start_date.end_of_month.end_of_day

    {
      total_sales: total_sales(start_date, end_date),
      total_passengers: sales.where(timestamp: start_date..end_date).sum(:number_of_passengers),
      sales_by_location: sales_by_location(start_date, end_date),
      sales_by_user: users.joins(:sales)
        .where(sales: { timestamp: start_date..end_date })
        .group('users.id')
        .select('users.name, COUNT(sales.id) as count, SUM(sales.amount) as total_amount')
    }
  end
end
