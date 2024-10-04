require 'rails_helper'

RSpec.describe Mutations::Vehicles::CreateVehicle, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<~GQL
      mutation CreateVehicle($vehicleInput: CreateVehicleInput!) {
        createVehicle(input: $vehicleInput) {  # Ensure this matches the argument name
          vehicle {
            id
            licensePlate
            brand
            vehicleType
            status
            capacity
          }
          errors
          message
        }
      }
    GQL
  end

  let(:variables) do
    {
"vehicleInput": {
  "vehicleInput": {
    "licensePlate":  "123ssxx0",
  "brand": "Tata",
  "vehicleType": "Truck",
  "status": "MAINTENANCE",
  "capacity": 1555
}
  }
}
  end

  it "creates a vehicle" do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['createVehicle']
    vehicle = data['vehicle'].first

    expect(vehicle['licensePlate']).to eq("123ssxx0")
    expect(vehicle['brand']).to eq('Tata')
    expect(vehicle['vehicleType']).to eq('Truck')
    expect(vehicle['status']).to eq('MAINTENANCE')
    expect(vehicle['capacity']).to eq(1555)  # Check that capacity is correct
    expect(data['message']).to eq('successfully created a vehicle')
    expect(data['errors']).to be_empty
  end
end
