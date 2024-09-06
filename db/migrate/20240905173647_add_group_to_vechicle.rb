class AddGroupToVechicle < ActiveRecord::Migration[7.2]
  def change
    add_reference :vehicles, :group, null: false, foreign_key: true
  end
end
