class ChnageAvailabilityTobeStringInGoods < ActiveRecord::Migration[7.2]
  def change
    change_column :goods, :availability, :string
  end
end
