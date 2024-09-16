class ::Mutations::Customer::CreateCustomer < Mutations::BaseMutation
argument :customer_input, Types::Customer::CustomerInputType, required: true

  type Types::Customer::CustomerResultType, null: false

  def resolve(customer_input:)
    service = ::CustomerServices::CreateCustomerServices.new(customer_input.to_h).execute

    if service.success?
      {
        customer: service.customer,
        message: "Successfully created new Customer.",
        success: true,
        errors: []
      }
    else
      {
        customer: nil,
        message: nil,
        success: false,
        errors: [ service.errors ]
      }
    end
  end
end
