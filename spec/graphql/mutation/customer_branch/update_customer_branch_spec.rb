require 'rails_helper'

RSpec.describe Mutations::CustomerBranch::UpdateCustomerBranch, type: :request do
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
     mutation updateBranch($input: UpdateCustomerBranchInput!) {
        updateCustomerbranch(input: $input) {
          customerBranch {
            id
            branchLocation
          }
            errors
            message
            success
        }
      }
    GRAPHQL
  end

  let(:variables) do
    {  input: {
      customerbranchInput: {
          customerId: customer.id,
          branchLocation: "AAA"
        },
        customerbranchId: customer_branch.id
      }
    }
  end

  it 'updates customer_branch' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    debugger
    expect(response).to be_successful
    json = JSON.parse(response.body)
    data = json['data']['updateCustomerbranch']

    expect(data['customerBranch']['branchLocation']).to eq('AAA')
    expect(data['success']).to eq(true)
  end
end
