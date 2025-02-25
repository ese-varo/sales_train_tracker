class Ticket < ApplicationRecord
  belongs_to :sale

  validates :ticket_number, presence: true, uniqueness: true
  validates :valid_until, presence: true

  def expired?
    valid_until < Time.current
  end

  def human_readable_expiry
    valid_until.strftime("%I:%M %p")
  end

  def to_print_format
    {
      ticket_number: ticket_number,
      sale_amount: sale.amount,
      passengers: sale.number_of_passengers,
      location: sale.location.name,
      expiry: human_readable_expiry,
      issued_at: sale.timestamp.strftime("%m%d%Y %I:%M %p"),
      cashier: sale.user.name
    }
  end
end
