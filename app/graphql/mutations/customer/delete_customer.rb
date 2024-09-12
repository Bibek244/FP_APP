class ::Mutations::Customer::DeleteCustomer < Mutations::BaseMutation
  argument :customer_id, ID, required: true

  type Types::Customer::CustomerResultType, null: false

  def resolve(customer_id:)
    service = ::CustomerServices::DeleteCustomerServices.new(customer_id).execute

    if service.success?
      {
        customer: service.customer,
        message: "Customer deleted Successfully",
        errors: nil,
        success: true
      }
    else
      {
        customer: nil,
        message: nil,
        errors: service.errors,
        success: false
      }
    end
  end
end
