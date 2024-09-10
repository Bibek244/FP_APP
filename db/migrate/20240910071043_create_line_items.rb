class CreateLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :line_items do |t|
      t.references :goods, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
