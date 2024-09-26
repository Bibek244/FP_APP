class ChangePhoneNoInCustomer < ActiveRecord::Migration[7.2]
  def change
    change_column :customers, :phone, :string
  end
end
