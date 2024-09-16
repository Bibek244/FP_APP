class CreateDeliveryOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_orders do |t|
      t.references :group, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :customer_branch, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :order_group, null: false, foreign_key: true
      t.string :status
      t.date :dispatched_date
      t.date :delivery_date

      t.timestamps
    end
  end
end
