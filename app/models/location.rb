class Location < ApplicationRecord
  belongs_to :organization
  has_many :users
  has_many :sales, dependent: :destroy
  has_many :printer_configs, dependent: :destroy

  validates :name, presence: true

  def active_users
    users.where(active: true)
  end

  def daily_sales(date = Date.today)
    sales.where(timestamp: date.beginning_of_day..date.end_of_day)
  end

  def total_sales_amount(start_date = nil, end_date = nil)
    scope = sales
    scope = scope.where(timestamp: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def default_printer
    printer_configs.find_by(active: true)
  end
end
