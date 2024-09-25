class AddParentOrderGroupIdToOrderGroups < ActiveRecord::Migration[7.2]
  def change
    add_column :order_groups, :parent_order_group_id, :integer, default: nil
    add_index :order_groups, :parent_order_group_id
  end
end
