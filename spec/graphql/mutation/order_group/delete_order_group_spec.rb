require 'rails_helper'

RSpec.describe Mutations::OrderGroups::DeleteOrderGroup, type: :request do
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
      mutation deleteOrderGroup($input: DeleteOrderGroupInput!){
        deleteOrderGroup(input: $input){
          order{
           id
          }
          message
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        orderId: order_group.id
      }
    }
  end

  it 'deletes an order group successfully' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['deleteOrderGroup']

    expect(data['message']).to eq("Successfully deleted the order group.")
    expect(data['errors']).to be_empty
  end

  it 'returns an error when deleteing order group which doesnot exist' do
    variables[:input][:orderId] = -1
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['deleteOrderGroup']

    expect(data['order']).to be_nil
    expect(data['message']).to be_nil
    expect(data['errors']).to_not be_empty

  end
end
