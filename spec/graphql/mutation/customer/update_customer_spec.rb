require 'rails_helper'

RSpec.describe Mutations::Customer::UpdateCustomer, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:customer) { Customer.create(name: "ABC", address: "Germany", phone: "1234567890", email: "abc@mail.com", group_id: group.id) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:variables) do
    {
      customerId: customer.id,
      customerInput: {
        name: "Customer A",
        phone: "1234567890",
        address: "AAA",
        email: "customer@mail.com"
    }
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation UpdateCustomer($customerId: ID!, $customerInput: CustomerInput!) {
        updateCustomer(input: { customerId: $customerId, customerInput: $customerInput }) {
          customer {
            name
            address
            email
          }
          message
          success
          errors
        }
      }
    GRAPHQL
  end


  it 'updates a customer ' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: @headers
    expect(response).to be_successful
    json= JSON.parse(response.body)
    data = json['data']['updateCustomer']

    expect(data['customer']['name']).to eq('Customer A')
    expect(data['customer']['address']).to eq('AAA')
    expect(data['success']).to eq(true)
  end
end
