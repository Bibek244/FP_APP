require 'rails_helper'

RSpec.describe Mutations::Goods::DeleteGoods, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group: group) }
  let!(:goods) { create(:goods, category: category, group: group) }

  let(:token) { login_user(user, group) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      mutation deleteGoods($id:  DeleteGoodsInput!){
        deleteGoods(input: $id){
          goods {
            id
            name
          }
          errors
          message
        }
      }
    GQL
  end

  let(:variables) do
    {
      id: {
        goodsId: goods.id
      }
    }
  end

  describe 'POST /graphql' do
    it 'deletes a goods item successfully' do
      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['deleteGoods']

      expect(data['message']).to eq('successfully deleted the product.')
      expect(data['errors']).to be_empty

      # Ensure the goods item is actually deleted from the database
      expect { goods.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns an error when trying to delete a non-existing goods item' do
      non_existing_goods_id = -1
      variables[:id][:goodsId] = non_existing_goods_id

      post '/graphql', params: { query: query, variables: variables.to_json }, headers: headers

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      data = json_response['data']['deleteGoods']

      expect(data['goods']).to be_nil
      expect(data['errors']).not_to be_empty
      expect(data['message']).to be_nil
    end
  end
end
