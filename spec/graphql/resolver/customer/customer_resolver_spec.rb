require 'rails_helper'

RSpec.describe Resolvers::Customer::SpecificCustomer, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:customer) { Customer.create(name: "ABC", address: "Germany", phone: "1234567890", email: "abc@mail.com", group_id: group.id) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
      query($id: ID!) {
        customer(customerId: $id) {
          name
          address
          email
        }
      }
    GRAPHQL
  end

  it 'returns the user' do
    post '/graphql', params: { query: query, variables: { id: customer.id } }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['customer']

    expect(data['name']).to eq('ABC')
    expect(data['address']).to eq('Germany')
    expect(data['email']).to eq('abc@mail.com')
  end
end
