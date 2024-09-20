class AddRecurringToOrderGroup < ActiveRecord::Migration[7.2]
  def change
    add_column :order_groups, :recurring, :boolean, default: false
    add_column :order_groups, :recurrence_frequency, :string
    add_column :order_groups, :next_due_date, :date
    add_column :order_groups, :recurrence_end_date, :date
  end
end
