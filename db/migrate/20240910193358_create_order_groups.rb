class CreateOrderGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :order_groups do |t|
      t.references :group, null: false, foreign_key: true
      t.date :planned_at, null: false
      t.references :customer, null: false, foreign_key: true
      t.references :customer_branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
