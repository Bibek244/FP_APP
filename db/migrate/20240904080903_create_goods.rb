class CreateGoods < ActiveRecord::Migration[7.2]
  def change
    create_table :goods do |t|
      t.string :name
      t.string :category
      t.string :sold_as
      t.string :unit
      t.integer :availability

      t.timestamps
    end
  end
end
