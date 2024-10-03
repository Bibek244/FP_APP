require 'rails_helper'

RSpec.describe Mutations::CustomerBranch::AddCustomerBranch, type: :request do
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
      mutation AddCustomerBranch($branchInput: AddCustomerBranchInput!){
       addCustomerbranch(input: $branchInput ) {
        customerBranch{
          branchLocation
          customerId
        }
        message
        success
        errors
        }
    }
    GRAPHQL
  end

  let(:variables) do
    {
      branchInput: {
        customerbranchInput: {
          customerId: customer.id,
          branchLocation: "Berlin"
          }
        }
    }
  end

  it 'creates a new Customer Branch' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['addCustomerbranch']

    # expect(data['customerBranch']['branchLocation']).to eq('Berlin')
    expect(data['success']).to eq(true)
    expect(data['errors']).to eq([])
  end
end
