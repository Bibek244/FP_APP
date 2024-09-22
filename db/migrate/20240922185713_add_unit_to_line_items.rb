class AddUnitToLineItems < ActiveRecord::Migration[7.2]
  def change
    add_column :line_items, :unit, :integer
  end
end
