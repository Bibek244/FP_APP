require 'rails_helper'

RSpec.describe Resolvers::CustomerBranch::AllBranches, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:customer) { Customer.create(name: "ABC", address: "Germany", phone: "1234567890", email: "abc@mail.com", group_id: group.id) }
  let!(:customer_branch1) { CustomerBranch.create(branch_location: "Berlin", customer_id: customer.id, group_id: group.id) }
  let!(:customer_branch2) { CustomerBranch.create(branch_location: "Frankfurt", customer_id: customer.id, group_id: group.id) }


  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
     query allBranches($customerId: ID!) {
       allBranches(customerId: $customerId) {
         branchLocation
       }
    }
    GRAPHQL
  end

  let (:variables) do
    {
      customerId: customer.id
    }
  end
  it 'returns customer Branch' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers

    json = JSON.parse(response.body)
    data = json['data']['allBranches']
    expect(data).to_not be_nil
  end
end
