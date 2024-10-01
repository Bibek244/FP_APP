require 'rails_helper'

RSpec.describe Mutations::Customer::CreateCustomer, type: :request do
  let!(:group) { create(:group) } # Creating a group using FactoryBot within Factories
  let!(:user) { create(:user, group: group) } # Creating user and assign to the group
  let!(:membership) { create(:membership, user: user, group: group) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:variables) do
    {
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
     mutation CreateCustomer($customerInput: CustomerInput!){
       createCustomer(input: {customerInput: $customerInput}){
         customer{
         name
         phone
         email
         address
         }
         message
         success
         errors
       }
     }
   GRAPHQL
  end

  it 'creates a customer' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    # debugger
    expect(response).to be_successful
    json = JSON.parse(response.body)
    data = json['data']['createCustomer']

    expect(data['customer']['name']).to eq('Customer A')
    expect(data['customer']['address']).to eq('AAA')
    expect(data['success']).to eq(true)
  end
end
