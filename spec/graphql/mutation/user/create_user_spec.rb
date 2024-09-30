require 'rails_helper'

RSpec.describe Mutations::Users::RegisterUser, type: :request do
  let!(:group) { Group.create(name: "AAA") }  # Create a valid group for testing

  let(:variables) do
    {
      email: "test@mail.com",
      password: "ValidPassword123!",
      passwordConfirmation: "ValidPassword123!",
      groupId: group.id
    }
  end

  let(:query) do
    <<-GRAPHQL
      mutation RegisterUser($email: String!, $password: String!, $passwordConfirmation: String!, $groupId: ID!) {
        registerUser(input: {email: $email, password: $password, passwordConfirmation: $passwordConfirmation, groupId: $groupId}) {
        user {
          id
          email
        }
        message
        error
      }
    }
    GRAPHQL
  end

  it 'creates a new user' do
    post '/graphql', params: { query: query, variables: variables }
    # headers: { 'Content-Type' => 'application/json' }

    expect(response).to be_successful
    json = JSON.parse(response.body)
    data = json['data']['registerUser']
    expect(data['user']['email']).to eq('test@mail.com')
    expect(data['error']).to be_nil
  end
end
