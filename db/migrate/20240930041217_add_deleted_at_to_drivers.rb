class AddDeletedAtToDrivers < ActiveRecord::Migration[7.2]
  def change
    add_column :drivers, :deleted_at, :datetime
    add_index :drivers, :deleted_at
  end
end
