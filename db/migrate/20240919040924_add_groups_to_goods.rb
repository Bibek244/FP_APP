class AddGroupsToGoods < ActiveRecord::Migration[7.2]
  def change
    add_reference :goods, :group, null: false, foreign_key: true
  end
end
