class ::Mutations::Customer::CreateCustomer < Mutations::BaseMutation
  argument :name, String, required: true
  argument  :address, String, required: true
  argument  :phone, Integer, required: true
  argument  :email, String, required: true
  argument  :group_id, ID, required: true

  field  :customer, Types::CustomerType, null: true
  field  :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(name:, address:, phone:, email:, group_id:)
    group = Group.find_by(id: group_id)
    if group.present?
      customer = Customer.new(name: name, address: address, phone: phone, email: email, group_id: group_id)
      if customer.save
        {
          customer: customer,
          error: [],
          success: true,
          message: "New customer is successfully created"
        }
      else
        {
          customer: nil,
          error: customer.errors.full_messages,
          success: false,
          message: "Customer is not created"
        }
      end
    else
      {
        customer: nil,
        error: [ "Group not found" ],
        success: false,
        message: "Group not present"
      }
    end
  end
end
