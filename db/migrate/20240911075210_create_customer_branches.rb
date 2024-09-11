class CreateCustomerBranches < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_branches do |t|
      t.string :branch_location
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
