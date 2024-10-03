require 'rails_helper'

RSpec.describe Resolvers::Customer::AllCustomers, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:customer1) { Customer.create(name: "ABC", address: "Germany", phone: "1234567890", email: "abc@mail.com", group_id: group.id) }
  let!(:customer2) { Customer.create(name: "BCD", address: "Italy", phone: "1234567880", email: "bcd@mail.com", group_id: group.id) }


  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
     query AllCustomers{
      allCustomers{
      name
      address
      phone
      }
    }
    GRAPHQL
  end

  it 'returns the user' do
    post '/graphql', params: { query: query }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['allCustomers']
    expect(data).to_not be_nil
  end
end
