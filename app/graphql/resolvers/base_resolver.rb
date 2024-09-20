module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver

    def authorize
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError, "You need to first have authorized permission to perform this action."
      end
    end
  end
end
