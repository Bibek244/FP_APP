require 'rails_helper'

RSpec.describe Mutations::Driver::CreateDriver, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end



  let(:variables) do
    {
      driverInput: {
        name: "DriverA",
        address: "aasd",
        phoneNo: 123456789,
        status: "AVAILABLE",
        email: "driver@mail.com"
      }
    }
  end

  let(:query) do
    <<-GRAPHQL
    mutation CreateDriver($driverInput: DriverInput!){
      addDriver(input: {driverInput: $driverInput}){
        driver{
          name
          address
          phoneNo
          email
        }
          success
          errors
          }
        }
    GRAPHQL
  end
  it 'creates a driver' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    debugger
    expect(response).to be_successful
    json = JSON.parse(response.body)
    data = json['data']['addDriver']
    expect(data['driver']['name']).to eq('DriverA')
    expect(data['driver']['email']).to eq('driver@mail.com')
    expect(data['success']).to eq(true)
    expect(data['errors']).to be_nil
  end
end
