class ChangeCategoryToReferenceInGoods < ActiveRecord::Migration[7.2]
  def change
    remove_column :goods, :category, :string
    add_reference :goods, :category, foreign_key: true
  end
end
