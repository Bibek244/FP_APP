class Mutations::Customer::ReactivateCustomer < Mutations::BaseMutation
  argument :customer_id, ID, required: true

  type Types::Customer::CustomerResultType, null: true

  def resolve (customer_id:)
    authorize
    current_user = context[:current_user]
    service = CustomerServices::ReactivateCustomerServices.new(customer_id, current_user).execute

    if service.success?
      { customer: service.customer, message: "Successfully reactiveted driver.", errors: [] }
    else
      { customer: nil, message: nil, errors: service.errors }
    end
  end
end
