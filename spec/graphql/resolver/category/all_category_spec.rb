require 'rails_helper'

RSpec.describe Resolvers::Category::AllCategory, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      query allCategory{
        allCategory{
          category {
            id
            name
          }
          errors
          message
        }
      }
    GQL
  end

  it 'Successfully fetches all category' do
    post '/graphql', params: { query: query }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['allCategory']

    expect(data['category']).to_not be_empty
    expect(data['errors']).to be_empty
    expect(data['message']).to eq("succesfully fetched category")
  end
end
