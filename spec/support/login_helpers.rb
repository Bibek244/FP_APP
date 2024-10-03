module LoginHelpers
  def login_user(user, group)
    post '/graphql', params: {
      query: <<-GRAPHQL,
        mutation LoginUser($email: String!, $password: String!, $groupId: ID!) {
        loginUser(input: { email: $email, password: $password, groupId: $groupId }) {
          user {
            id
          }
          message
          error
          token
        }
      }
      GRAPHQL

      variables: {
        email: user.email,
        password: user.password,
        groupId: group.id
      }
    }
    json_response = JSON.parse(response.body)
    json_response['data']['loginUser']['token']
  end
end

RSpec.configure do |config|
  config.include LoginHelpers
end
