require 'rails_helper'

RSpec.describe Mutations::Category::CreateCategory, type: :request do
  let!(:group) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:membership) { create(:membership, user: user, group: group) }

  before do
    token = login_user(user, group)
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  let(:query) do
    <<~GQL
    mutation CreateCatagory($input: CreateCategoryInput! ){
      createCategory(input: $input){
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
      input: {
        categoryInput: {
          name: "FUEL"
        }
    }
  }
  end

  let(:error_variables) do
    {
      input: {
        categoryInput: {
          name: ""
        }
    }
  }
  end

  it 'creates a categroy successfully' do
    post '/graphql', params: { query: query, variables: variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['createCategory']

    category = data['category'].first

    expect(category['name']).to eq("FUEL")
    expect(data['message']).to eq("Category created successfully.")
    expect(data['errors']).to eq([])
  end

  it 'doesnot create category' do
    post '/graphql', params: { query: query, variables: error_variables }, headers: @headers
    expect(response).to be_successful

    json = JSON.parse(response.body)
    data = json['data']['createCategory']

    expect(data['category']).to be_nil
    expect(data['message']).to eq('Failed to create category.')
    expect(data['errors']).to eq([ "Name can't be blank" ])
  end
end
