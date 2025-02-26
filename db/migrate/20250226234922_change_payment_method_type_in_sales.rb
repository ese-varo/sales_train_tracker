class ChangePaymentMethodTypeInSales < ActiveRecord::Migration[8.0]
  def change
    change_column :sales, :payment_method, :integer
  end
end
