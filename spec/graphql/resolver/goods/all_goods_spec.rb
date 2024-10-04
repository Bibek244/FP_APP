require 'rails_helper'

RSpec.describe Resolvers::Goods::AllGoods, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }
  let!(:goods) { create(:goods, category: category, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      query getAllGoods {
        goods{
          goods {
            id
            name
            category{
              id
            }
            soldAs
            unit
            availability
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
    data = json_response['data']['goods']

    expect(data['goods']).to_not be_nil
    expect(data['errors']).to be_empty
    expect(data['message']).to eq("Successfully featched all the goods")
  end
end
