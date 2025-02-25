class PrinterConfig < ApplicationRecord
  belongs_to :location

  validates :name, presence: true
  validates :device_id, presence: true

  def self.find_available_printers
    # Implementation depends on printer library
    # This would return a list of available printers on the device
  end

  def test_print
    # Send a test page to this printer configuration
    # TicketPrintService.new(nil, self).print_test
  end
end
