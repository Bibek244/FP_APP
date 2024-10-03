require 'rails_helper'

RSpec.describe Resolvers::Driver::SpecificDriver, type: :request do
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
      query($id: ID!){
        driver(driverId: $id){
          name
          email
          phoneNo
          address
        }
      }
    GRAPHQL
  end

  it 'returns driver data' do
    post '/graphql', params: { query: query, variables: { id: driver.id } }, headers: @headers

    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['driver']

    expect(data['name']).to eq('Driver')
    expect(data['email']).to eq('driver@mail.com')
    expect(data['address']).to eq('United USA')
  end
end
