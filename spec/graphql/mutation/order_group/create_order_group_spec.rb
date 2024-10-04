require 'rails_helper'

RSpec.describe Mutations::OrderGroups::CreateOrderGroup, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }
  let!(:goods) { create(:goods, category: category, group: group) }
  let!(:customer) { create(:customer, group: group) }
  let!(:customer_branch) { create(:customer_branch, customer: customer, group: group) }
  let!(:driver) { create(:driver, group: group) }
  let!(:vehicle) { create(:vehicle, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      mutation CreateOrderGroup($groupOrder: CreateOrderGroupInput!){
        createOrderGroup(input: $groupOrder){
          order{
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
      groupOrder: {
        createOrder: {
          plannedAt: (Date.today + 1).to_s,
          customerBranchId: customer_branch.id,
          recurring: false,
          recurrenceFrequency: nil,
          recurrenceEndDate: nil,
          deliveryOrderAttributes: {
            driverId: driver.id,
            vehicleId: vehicle.id,
            status: "PENDING",
            linedItemsAttributes:
            [
              {
                goodsId: goods.id,
                quantity: 50,
                unit: "LITERS"
              }, {
                goodsId: goods.id,
                quantity: 500,
                unit: "LITERS"
              }
            ]
          }
        }
      }
    }
  end

  it 'creates an order group successfully' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['createOrderGroup']

    expect(data['order']).not_to be_nil
    expect(data['order']['plannedAt']).to eq((Date.today + 1).to_s)
    expect(data['order']['customer']['id']).to eq(customer.id.to_s)
    expect(data['order']['customerBranch']['id']).to eq(customer_branch.id.to_s)
    expect(data['order']['recurring']).to be_falsey
    expect(data['message']).to eq('successfully created a order.')
    expect(data['errors']).to be_empty
  end

  it 'returns an error when creating an order group with invalid data' do
    variables[:groupOrder][:createOrder][:plannedAt] = Date.yesterday
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['createOrderGroup']

    expect(data['order']).to be_nil
    expect(data['errors']).not_to be_empty
    expect(data['message']).to eq('Failed to created a order.')
  end
end
