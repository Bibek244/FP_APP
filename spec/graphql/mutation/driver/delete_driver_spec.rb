require 'rails_helper'

RSpec.describe Mutations::Driver::DeleteDriver, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:driver) { Driver.create(name: "Driver", email: "driver@mail.com", phone_no: "1232444444", address: "United USA", status: 'AVAILABLE', group_id: group.id) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization"=> "Bearer #{token}" }
  end

  let(:query) do
    <<-GRAPHQL
      mutation deleteDriver($driverinput: DeleteDriverInput!){
        deleteDriver(input:$driverinput){
          driver{
            name
            address
            phoneNo
            email
          }
          errors
          message
          success
        }
      }
    GRAPHQL
  end

  let(:variables) do
    {
      "driverinput": {
        "driverId": driver.id
      }
    }
  end

  it 'deletes a driver' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['deleteDriver']
    expect(data['success']).to eq(true)
    expect(data['errors']).to be_nil
  end
end
