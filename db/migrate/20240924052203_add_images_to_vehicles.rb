class AddImagesToVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :images, :json
  end
end
