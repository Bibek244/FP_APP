require 'rails_helper'

RSpec.describe Resolvers::CustomerBranch::SpecificBranch, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:customer) { Customer.create(name: "ABC", address: "Germany", phone: "1234567890", email: "abc@mail.com", group_id: group.id) }
  let!(:customer_branch) { CustomerBranch.create(branch_location: "Berlin", customer_id: customer.id, group_id: group.id) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
      query($id: ID!) {
      customerBranch(id: $id){
        branchLocation
       }
      }
    GRAPHQL
  end

  it 'returns customer Branch' do
    post '/graphql', params: { query: query, variables: { id: customer_branch.id } }, headers: @headers
    json = JSON.parse(response.body)
    data = json['data']['customerBranch']
    expect(data['branchLocation']).to eq('Berlin')
  end
end
