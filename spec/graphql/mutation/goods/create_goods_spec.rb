require 'rails_helper'

RSpec.describe Mutations::Goods::CreateGoods, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      mutation CreateGoods($goodsInput: CreateGoodsInput!) {
        createGoods(input: $goodsInput) {
          goods {
            id
            name
            soldAs
            availability
            unit
            category {
              id
              name
            }
          }
          errors
          message
        }
      }
    GQL
  end

  let(:variables) do
    {
      goodsInput: {
        goodsInput: {
          name: "New Product",
          soldAs: "Each",
          unit: 'liter',
          availability: "IN_STOCK",
          categoryId: category.id
        }
      }
    }
  end

  describe 'POST /graphql' do
    it 'creates a goods item successfully' do
      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers, as: :json
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['createGoods']
      goods = data['goods'].first

      expect(data['goods']).not_to be_empty
      expect(goods['name']).to eq('New Product')
      expect(goods['soldAs']).to eq('Each')
      expect(goods['unit']).to eq('liter')
      expect(goods['availability']).to eq('IN_STOCK')
      expect(goods['category']['id']).to eq(category.id.to_s)
      expect(data['message']).to eq('Successfully created a product.')
      expect(data['errors']).to be_empty
    end

    it 'returns an error when creating goods with invalid data' do
      variables[:goodsInput][:goodsInput][:name] = "a"

      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers, as: :json

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['createGoods']

      expect(data['goods']).to be_nil
      expect(data['errors']).to eq([ "Validation failed: Name is too short (minimum is 3 characters)" ])
      expect(data['message']).to be_nil
    end
  end
end
