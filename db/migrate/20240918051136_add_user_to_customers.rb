class AddUserToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_reference :customers, :user, null: false, foreign_key: true
  end
end
