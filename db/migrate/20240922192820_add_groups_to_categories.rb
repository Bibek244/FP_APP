class AddGroupsToCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :categories, :group, null: false, foreign_key: true
  end
end
