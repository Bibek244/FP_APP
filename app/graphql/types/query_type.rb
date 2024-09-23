# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
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
    field :sold_as, resolver: Resolvers::Goods::SoldAs,
      description: "Resolver to get all the selling category"

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

    # Query for driver
    field :StatusEnum, resolver: Resolvers::Driver::DriverStatus
    description :"Retrive all the status available for driver"

    # QUERY FOR CUSTOMER
    field :customer, resolver: Resolvers::Customer::SpecificCustomer, description: "Resolver to Fetch a specific Customer"
    field :all_customers, resolver: Resolvers::Customer::AllCustomers, description: "Resolver to Fetch all customer "

    # QUERY FOR CUSTOMERBRANCH
    field :customerBranch, resolver: Resolvers::CustomerBranch::SpecificBranch, description: "Resolver to Fetch a specific Branch"
    field :allBranches, resolver: Resolvers::CustomerBranch::AllBranches, description: "Resolver to Fetch all Branches of a customer"

    # QUERY FOR DRIVER
    field :driver, resolver: Resolvers::Driver::SpecificDriver, description: "Resolver for Specific Driver "
    field :alldrivers, resolver: Resolvers::Driver::AllDrivers, description: "Resolver for all Driver in an Group "

    # QUERY FOR DELIVERY Order
    field :deliveryorder, resolver: Resolvers::DeliveryOrder::SpecificDeliveryOrder, description: "Resolver for Specific Delivery Order"
    field :alldeliveryorder, resolver: Resolvers::DeliveryOrder::AllDeliveryOrder, description: "Resolver for All Delivery Order of a group"


    field :status_enum_values, resolver: Resolvers::Vehicles::AllStatus,
      description: "Retrieve the possible values for the StatusType enum"

    # Query FOR ORDER_Group
    field :all_order_group, resolver: Resolvers::OrderGroups::AllOrderGroup,
      description: "Resolver to fetch all order_groups"
    field :specific_order_group, resolver: Resolvers::OrderGroups::SpecificOrderGroup,
      description: "Resolver to fetch specific order group"
    field :unit, resolver: Resolvers::OrderGroups::UnitResolver,
      description: "Resolver to fetch unit."

    # QUERY FOR CATEGORY
    field :all_category, resolver: Resolvers::Category::AllCategory,
      description: "Resolver to fetch all categories"
    field :specific_category, resolver: Resolvers::Category::SpecificCategory,
      description: "Resovler to fetch specific order_group"
  end
end
