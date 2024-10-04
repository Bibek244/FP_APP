require 'rails_helper'

RSpec.describe Resolvers::Vehicles::AllVehicles, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:vehicle) { create(:vehicle, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      query allVehicles{
        vehicles{
    	    vehicle{
            id
            brand
            deletedAt
          }
          message
          errors
        }
      }
    GQL
  end

  it 'Successfully fetches all goods' do
    post '/graphql', params: { query: query }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['vehicles']

    expect(data['vehicle']).to_not be_nil
    expect(data['errors']).to be_empty
    expect(data['message']).to eq("Successfully featched all the vehicles")
  end
end
