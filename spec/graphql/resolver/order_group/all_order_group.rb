require 'rails_helper'

RSpec.describe Resolvers::Vehicles::AllVehicles, type: :request do
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
      query fetchAllOrderGroup{
        allOrderGroup{
          order{
            id
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
              deliveryDate
              dispatchedDate
      	        driver{
                  id
                }
                vehicle{
                  id
                }
              orderGroupId
              lineItems{
                id
                goods{
                  id
                  name
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

  it 'Successfully fetches all order group' do
    post '/graphql', params: { query: query }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['allOrderGroup']
    data.each do |order_data|
      expect(order_data['order']).to_not be_empty
      expect(order_data['errors']).to be_empty
      expect(order_data['message']).to eq("Successfully fetched the order group.")
    end
  end
end
