class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :brand
      t.string :model
      t.string :vehicle_type
      t.integer :status
      t.integer :capacity
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
