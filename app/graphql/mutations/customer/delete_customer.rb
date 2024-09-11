class ::Mutations::Customer::DeleteCustomer < Mutations::BaseMutation
  argument :customer_id, ID, required: true

  field  :customer, Types::CustomerType, null: true
  field  :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(customer_id:)
    customer = Customer.find_by(id: customer_id)
    if customer.present?
      Customer.destroy(customer.id)
      {
        customer: nil,
        error: [],
        success: true,
        message: "Customer is deleted successfully"
      }
    else
      {
        customer: nil,
        error: [],
        success: false,
        message: "CustomerID is not present"
      }
    end
  end
end
