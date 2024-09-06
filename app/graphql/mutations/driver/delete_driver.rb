class ::Mutations::Driver::DeleteDriver < Mutations::BaseMutation
  argument :driver_id, ID, required: true

  field :driver, Types::DriverType, null: true
  field :error, [ String ], null: false
  field :message, String, null: true

  def resolve(driver_id:)
    driver = Driver.find(driver_id)
    # driver.destroy(user_id: user_id)
    if driver.present?
      Driver.destroy(driver.id)
       {
          driver: nil,
          error: [],
          message: "Driver is sucessfully deleted"
       }
    else
       raise GraphQL::ExecutionError, driver.errors.full_messages.join(", ")
    end
  end
end
