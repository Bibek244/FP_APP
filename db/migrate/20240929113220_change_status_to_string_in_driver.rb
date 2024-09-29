class ChangeStatusToStringInDriver < ActiveRecord::Migration[7.2]
  def change
    change_column :drivers, :status, :string
  end
end
