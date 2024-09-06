class ::Mutations::Driver::CreateDriver < Mutations::BaseMutation
  argument :name, String, required: true
  argument :email, String, required: true
  argument :address, String, required: true
  argument :phone_no, Integer, required: true
  argument :status, Types::StatusEnum, required: true
  argument :group_id, ID, required: true
  argument :user_id, ID, required: true

  field :driver, Types::DriverType, null: false
  field :error, [ String ], null: true
  field :message, String, null: true

  def resolve(name:, email:, address:, phone_no:, status:, group_id:, user_id:)
    driver = Driver.new(name: name, email: email, address: address, phone_no: phone_no, status: status, group_id:, user_id: user_id)
    if driver.save
       {
         driver: driver,
          error: nil,
          message: "New Driver is sucessfully Created"
       }
    else
       raise GraphQL::ExecutionError, driver.errors.full_messages.join(", ")
    end
  end
end
