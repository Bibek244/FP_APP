class ::Mutations::Customer::UpdateCustomer < Mutations::BaseMutation
  argument :customer_input, Types::Customer::CustomerInputType, required: true
  argument :customer_id, ID, required: true

  type Types::Customer::CustomerResultType, null: true

  def resolve(customer_input:, customer_id:)
    authorize
    service = ::CustomerServices::UpdateCustomerServices.new(customer_id, customer_input.to_h).execute

    if service.success?
      {
        customer: service.customer,
        message: "Successfully updated Customer.",
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
