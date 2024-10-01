require 'rails_helper'

RSpec.describe Mutations::Customer::DeleteCustomer, type: :request do
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
      customerId: customer.id
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation DeleteCustomer($customerId: ID!){
      deleteCustomer(input: {customerId: $customerId}){
      customer{
      name
      email
         }
        success
        errors
      }
      }
    GRAPHQL
  end

  it 'deletes a customer' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['deleteCustomer']

    expect(data['success']).to eq(true)
    expect(data['errors']).to be_nil
  end
end
