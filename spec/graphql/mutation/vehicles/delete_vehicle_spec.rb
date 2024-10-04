require 'rails_helper'

RSpec.describe Mutations::Vehicles::DeleteVehicle, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:vehicle) { create(:vehicle, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      mutation DeleteVehicle($deleteVehicle: DeleteVehicleInput!) {
        deleteVehicle(input: $deleteVehicle) {
          vehicle {
            id
          }
          message
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {

    deleteVehicle: {
        vehicleId: vehicle.id
        }
    }
  end

  describe 'POST /graphql' do
    it 'deletes a vehicle successfully' do
      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

      expect(response).to be_successful
      json_response = JSON.parse(response.body)
      data = json_response['data']['deleteVehicle']

      expect(data['message']).to eq('Successfully deleted vehicle.')
      expect(data['errors']).to be_empty
    end

    it 'returns an error when the vehicle does not exist' do
      non_existing_vehicle_id = -1

      variables[:deleteVehicle][:vehicleId] = non_existing_vehicle_id

      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['deleteVehicle']

      expect(data['vehicle']).to be_nil
      expect(data['message']).to eq('Failed to delete vehicle')
      expect(data['errors']).not_to be_empty
    end
  end
end
