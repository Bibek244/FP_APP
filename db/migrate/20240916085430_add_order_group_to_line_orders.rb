class AddOrderGroupToLineOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :line_items, :order_group, null: false, foreign_key: true
  end
end
