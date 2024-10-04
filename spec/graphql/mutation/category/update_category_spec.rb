require 'rails_helper'

RSpec.describe Mutations::Category::UpdateCategory, type: :request do
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
      mutation updateCategory($updateCategory: UpdateCategoryInput!){
        updateCategory(input: $updateCategory){
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
      updateCategory: {
        id: category.id,
        categoryInput: {
          name: "GLUE"
        }
      }
    }
  end

  it 'updates the category' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['updateCategory']
    
    category = data['category'].first

    expect(category['name']).to eq("GLUE")
    expect(data['message']).to eq("Category updated successfully.")
    expect(data['errors']).to eq([])
  end
end
