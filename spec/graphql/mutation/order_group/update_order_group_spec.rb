require 'rails_helper'

RSpec.describe Mutations::OrderGroups::UpdateOrderGroup, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:driver) { create(:driver, group: group) }
  let!(:vehicle) { create(:vehicle, group: group) }
  let!(:category) { create(:category, group: group) }
  let!(:goods) { create(:goods, category: category, group: group) }
  let!(:customer) { create(:customer, group: group) }
  let!(:customer_branch) { create(:customer_branch, customer: customer, group: group) }
  let!(:order_group) { create(:order_group, group: group, customer: customer, customer_branch: customer_branch) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }


  let(:query) do
    <<~GQL
     mutation UpdateOrderGroup($orderGroup: UpdateOrderGroupInput!){
      updateOrderGroup(input: $orderGroup){
          order {
            id
                plannedAt
                customer{
                  id
                  name
                }
			          customerBranch{
                  id
                  branchLocation
                }
                childOrderGroups{
                  id
                }
                recurring
                recurrenceFrequency
                recurrenceEndDate
                nextDueDate
                parentOrderGroupId
                deliveryOrder{
                  id
                  orderGroupId
                  deliveryDate
                  dispatchedDate
                  vehicle{
                    id
                    brand
                    vehicleType
                  }
                  status
                	  driver{
                      id
                      name
                    }
                  lineItems{
                    id
                    goods{
                      id
                      name
                      category{
                        name
                      }
                    }
                    quantity
                    unit
                  }
                }
              }
              errors
              message
        }
      }
    GQL
  end

  let(:variables) do
    {
      orderGroup: {
        orderGroupId: order_group.id,
        updateOrder: {
          plannedAt: (Date.today + 2).to_s,
          customerBranchId: customer_branch.id,
          recurring: false,
          deliveryOrderAttributes: {
            driverId: driver.id,
            vehicleId: vehicle.id,
            status: "PENDING",
            linedItemsAttributes: [
              { goodsId: goods.id, quantity: 50, unit: "LITERS" }
            ]
          }
        }
      }
    }
  end


  it 'updates an order group successfully' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['updateOrderGroup']

    expect(data['order']['plannedAt']).to eq((Date.today + 2).to_s)
    expect(data['order']['customerBranch']['id']).to eq(customer_branch.id.to_s)
    expect(data['order']['deliveryOrder']['driver']['id']).to eq(driver.id.to_s)
    expect(data['order']['deliveryOrder']['vehicle']['id']).to eq(vehicle.id.to_s)
    expect(data['message']).to eq("successfully updated a order.")
    expect(data['errors']).to be_empty
  end

  it 'returns an error when updating with invalid data' do
    variables[:orderGroup][:updateOrder][:plannedAt] = Date.yesterday

    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['updateOrderGroup']

    expect(data['order']).to be_nil
    expect(data['errors']).not_to be_empty
  end
end
