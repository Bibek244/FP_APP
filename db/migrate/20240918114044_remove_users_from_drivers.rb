class RemoveUsersFromDrivers < ActiveRecord::Migration[7.2]
  def change
    remove_reference :drivers, :user, null: false, foreign_key: true
  end
end
