require 'rails_helper'

RSpec.describe Mutations::Driver::UpdateDriver, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:driver) { Driver.create(name: "Driver", email: "driver@mail.com", phone_no: "1234567890", address: "United USA", status: 'AVAILABLE', group_id: group.id) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization"=> "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
     mutation updateDriver($driverinput: UpdateDriverInput!){
      updateDriver(input:$driverinput){
          driver{
            name
            address
            phoneNo
            groupId
            email
            status
          }
          errors
          success
          message
        }
      }
    GRAPHQL
  end

  let(:variables) do
    {
      driverinput: {
        driverId: driver.id,
        driverInput: {
          name: "Update Driver",
          address: "update",
          phoneNo: "0987654321",
          status: "DEPLOYED",
          email: "updat@ail.com"
        }
      }
    }
  end
  it 'updates a driver' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: @headers

    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['updateDriver']

    expect(data['driver']['name']).to eq('Update Driver')
    expect(data['driver']['email']).to eq('updat@ail.com')
    expect(data['driver']['status']).to eq('DEPLOYED')
    expect(data['success']).to eq(true)
    expect(data['errors']).to eq([])
  end
end
