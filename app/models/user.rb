class User < ApplicationRecord
  belongs_to :organization
  belongs_to :location
  has_many :sales

  has_secure_password

  enum :role, { cashier: 0, manager: 1, owner: 2 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :location_id, presence: true, if: :cashier?

  scope :active, -> { where(active: true) }

  def can_manage_users?
    manager? || owner?
  end

  def can_view_organization_reports?
    owner? || manager?
  end

  def sales_today
    sales.where(timestamp: Date.today.beginning_of_date..Date.today.end_of_day)
  end

  def total_sales_amount(start_date = nil, end_date = nil)
    scope = sales
    scope = scope.where(timestamp: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end
end
