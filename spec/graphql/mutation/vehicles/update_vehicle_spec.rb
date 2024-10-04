require 'rails_helper'

RSpec.describe Mutations::Vehicles::UpdateVehicle, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:vehicle) { create(:vehicle, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
     mutation UpdateVehicle($updateVehicle: UpdateVehicleInput!){
      updateVehicle(input: $updateVehicle) {
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
      updateVehicle: {
        vehicleId: vehicle.id,
        vehicleInput: {
          licensePlate: "123ssxx0",
          brand: "Tata Updated",
          vehicleType: "Truck",
          status: "AVAILABLE",
          capacity: 2000
        }
      }
    }
  end

  describe 'POST /graphql' do
    it 'updates a vehicle successfully' do
      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['updateVehicle']

      vehicle = data['vehicle'].first

      expect(vehicle).not_to be_nil
      expect(vehicle['licensePlate']).to eq('123ssxx0')
      expect(vehicle['brand']).to eq('Tata Updated')
      expect(vehicle['vehicleType']).to eq('Truck')
      expect(vehicle['status']).to eq('AVAILABLE')
      expect(vehicle['capacity']).to eq(2000)
      expect(data['message']).not_to be_nil
      expect(data['errors']).to be_empty
    end

    it 'returns an error when vehicle does not exist' do
      non_existing_vehicle_id = -1

      variables[:updateVehicle][:vehicleId] = non_existing_vehicle_id

      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['updateVehicle']

      expect(data['vehicle']).to be_nil
      expect(data['errors']).not_to be_empty
      expect(data['message']).to be_nil
    end
  end
end
