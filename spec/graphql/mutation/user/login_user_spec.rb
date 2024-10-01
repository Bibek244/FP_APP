require 'rails_helper'

RSpec.describe Mutations::Users::LoginUser, type: :request do
  let!(:group) { create(:group) } # Creating a group using FactoryBot
  let!(:user) { create(:user, group: group) } # Creating user and assign to the group
  let!(:membership) { create(:membership, user: user, group: group) }
  let(:variables) do
    {
      email: "abc@mail.com",
      password: "test@password",
      group_id: group.id
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation LoginUser($email: String!, $password: String!, $group_id: ID!) {
        loginUser(input: { email: $email, password: $password, groupId: $group_id }) {
          user {
            id
            email
          }
          message
          error
          token
        }
      }
    GRAPHQL
  end

  it "logs in a user" do
    post '/graphql', params: { query: query, variables: variables }

    expect(response).to be_successful
    json = JSON.parse(response.body)
    data = json['data']['loginUser']
    expect(data['user']['email']).to eq('abc@mail.com')
    expect(data['message']).to eq('Login Successful')
  end
end
