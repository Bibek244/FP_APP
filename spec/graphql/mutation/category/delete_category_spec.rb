require 'rails_helper'

RSpec.describe Mutations::Category::DeleteCategory, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }
  let!(:category) { create(:category, group_id: group.id) }
  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Breaer #{token}" }
  end

  let(:query) do
    <<~GQL
      mutation deletecatagory($deleteCategory: DeleteCategoryInput!){
        deleteCategory(input : $deleteCategory) {
          category{
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
      deleteCategory: {
        id: category.id
      }
    }
  end

  it 'deletes the category' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['deleteCategory']

    expect(data['category']).to be_nil
    expect(data['message']).to eq("Category deleted successfully.")
    expect(data['errors']).to eq([])
  end
end
