class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :model
      t.string :vin
      t.string :year
      t.integer :mileage
      t.integer :capacity
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
