class AddGroupToCustomerBranch < ActiveRecord::Migration[7.2]
  def change
    add_reference :customer_branches, :group, null: false, foreign_key: true
  end
end
