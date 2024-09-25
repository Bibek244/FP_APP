class AddSkipUpdateToOrderGroup < ActiveRecord::Migration[7.2]
  def change
    add_column :order_groups, :skip_update, :boolean, default: false
  end
end
