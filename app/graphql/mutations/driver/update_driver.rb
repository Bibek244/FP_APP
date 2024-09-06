class ::Mutations::Driver::UpdateDriver < Mutations::BaseMutation
  argument :driver_id, ID, required: true
  argument :name, String, required: true
  argument :email, String, required: true
  argument :address, String, required: true
  argument :phone_no, Integer, required: true
  argument :status, Types::StatusEnum, required: true

  field :driver, Types::DriverType, null: true
  field :error, [ String ], null: false
  field :message, String, null: true

  def resolve(driver_id:, name:, email:, address:, phone_no:, status:)
    driver = Driver.find_by(id: driver_id)
    if driver.present?
      update = driver.update(name: name, email: email, address: address, phone_no: phone_no, status: status)
      if update
        {
          driver: driver,
          error: [],
          message: "Driver's value is sucessfully updated"
        }
      else
      { driver: nil, message: nil, error: [ driver.errors.full_messages ] }
      end
    else
      { driver: nil, message: nil, error: [ "Driver not found " ] }
    end
  end
end
