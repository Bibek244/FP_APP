# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
    field :customer, resolver: Resolvers::Customer::SpecificCustomer
    field :all_customers, resolver: Resolvers::Customer::AllCustomers
    field :customerBranch, resolver: Resolvers::CustomerBranch::SpecificBranch
    field :allBranches, resolver: Resolvers::CustomerBranch::AllBranches

    field :driver, resolver: Resolvers::Driver::SpecificDriver
    field :alldrivers, resolver: Resolvers::Driver::AllDrivers

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
    argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end


    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me

    # QUERY FOR GOODS
    field :goods, resolver: Resolvers::Goods::AllGoods,
      description: "Resolver to get all goods"
    field :specific_goods, resolver: Resolvers::Goods::SpecificGoods,
     description: "Resolver to get specific goods"

    # QUERY FOR GROUPS
    field :all_groups, resolver: Resolvers::Groups::AllGroups,
      description: "Resolver to fetch all groups"
    field :specific_group, resolver: Resolvers::Groups::SpecificGroup,
      description: "Resolver for specific group"

    # QUERY FOR VEHICLES
    field :vehicles, resolver: Resolvers::Vehicles::AllVehicles,
      description: "Resolver to fetch all vehicle"
    field :specific_vehicle, resolver: Resolvers::Vehicles::SpecificVehicle,
      description: "Resolver to fetch specific vehicle"
    field :status_enum_values, resolver: Resolvers::Vehicles::AllStatus,
      description: "Retrieve the possible values for the StatusType enum"
  end
end
