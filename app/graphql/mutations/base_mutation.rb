# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authorize
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError, "You need to first have authorized permission to perform this action."
      end
    end
  end
end
