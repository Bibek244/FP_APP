class AddDeliveryOrderInLineItem < ActiveRecord::Migration[7.2]
  def change
    add_reference :line_items, :delivery_order, null: false, foreign_key: true
  end
end
