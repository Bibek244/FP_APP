class ChangePhoneNoInDrivers < ActiveRecord::Migration[7.2]
  def change
    change_column :drivers, :phone_no, :string
  end
end
