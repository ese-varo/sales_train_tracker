class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :organization
  has_one :ticket, dependent: :destroy

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :number_of_passengers, presence: true, numericality: { greater_than: 0 }

  before_create :set_organization
  after_create :generate_ticket

  enum :payment_method, { cash: 0, credit_card: 1, debit_card: 2, other: 3 }

  def generate_ticket
    valid_until = Time.current + 1.hour # Default expiration 1 hour
    ticket_number = "#{Time.current.to_i}-#{id}"

    create_ticket(
      ticket_number: ticket_number,
      valid_until: valid_until,
      printed: false
    )
  end

  def print_ticket(printer_config = nil)
    printer_config ||= location.default_printer

    # Implementation depend on printer library
    # printer_service = TicketPrintService.new(self, printer_config)
    # result = printer_service.print
    #
    # if result[:success]
    #   ticket.update(printed: true)
    # end
    #
    # result
  end

  private
    def set_organization
      self.organization_id = location.organization_id if organization_id.nil? && location
    end
end
