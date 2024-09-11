class ::Mutations::Customer::UpdateCustomer < Mutations::BaseMutation
  argument :name, String, required: true
  argument  :address, String, required: true
  argument  :phone, String, required: true
  argument  :email, String, required: true
  argument  :customer_id, ID, required: true

  field  :customer, Types::CustomerType, null: true
  field  :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(name:, address:, phone:, email:, customer_id:)
    customer = Customer.find_by(id: customer_id)
    if customer.present?
      customer.update(name: name, address: address, phone: phone, email: email)
      if customer.save
        {
          customer: customer,
          error: [],
          success: true,
          message: "Customer data is updated sucessfully"
        }
      else
         raise GraphQL::ExecutionError, customer.errors.full_messages
      end
    else
      {
      customer: customer,
      error: [],
      success: false,
      message: "Customer doesnot exists "
    }

    end
  end
end
