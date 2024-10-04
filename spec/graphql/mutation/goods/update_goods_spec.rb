require 'rails_helper'

RSpec.describe Mutations::Goods::UpdateGoods, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }
  let!(:goods) { create(:goods, category: category, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
    mutation UpdateGoods($goodsInput: UpdateGoodsInput!) {
      updateGoods(input: $goodsInput ) {
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
        goodsId: goods.id,
        goodsInput: {
          name: "Updated Product",
          soldAs: "Each",
          unit: 'liter',
          availability: "IN_STOCK",
          categoryId: category.id
        }
      }
    }
  end

  it 'returns an error when updating goods with invalid data' do
    variables[:goodsInput][:goodsInput][:name] = "a"

    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['updateGoods']

    expect(data['goods']).to be_nil
    expect(data['errors']).to eq([ "Validation failed: Name is too short (minimum is 3 characters)" ])
    expect(data['message']).to be_nil
  end

  it 'updates a goods item successfully' do
    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful

    json_response = JSON.parse(response.body)
    data = json_response['data']['updateGoods']
    goods_updated = data['goods'].first

    expect(data['goods']).not_to be_empty
    expect(goods_updated['name']).to eq('Updated Product')
    expect(goods_updated['soldAs']).to eq('Each')
    expect(goods_updated['unit']).to eq('liter')
    expect(goods_updated['availability']).to eq('IN_STOCK')
    expect(goods_updated['category']['id']).to eq(category.id.to_s)
    expect(data['message']).to eq('Successfully updated a product.')
    expect(data['errors']).to be_empty
  end

  it 'returns an error when goods item does not exist' do
    variables[:goodsInput][:goodsId] = -1  # Set a non-existing ID

    post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
    expect(response).to be_successful


    json_response = JSON.parse(response.body)
    data = json_response['data']['updateGoods']

    expect(data['goods']).to be_nil
    expect(data['errors']).not_to be_empty
    expect(data['message']).to be_nil
  end
end
