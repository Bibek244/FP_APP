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
    field :availibility, resolver: Resolvers::Goods::AvailabilityResolver,
      description: "Resovler for availibility enum"

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
    field :active_vehicles, resolver: Resolvers::Vehicles::ActiveVehicles,
      description: "Resolver to fetch all active vehicle"

    # QUERY FOR CUSTOMER
    field :customer, resolver: Resolvers::Customer::SpecificCustomer,
      description: "Resolver to Fetch a specific Customer"
    field :all_customers, resolver: Resolvers::Customer::AllCustomers,
      description: "Resolver to Fetch all customer "
    field :active_customers, resolver: Resolvers::Customer::ActiveCustomers,
      description: "Resovler to Fetch active customers"

    # QUERY FOR CUSTOMERBRANCH
    field :customerBranch, resolver: Resolvers::CustomerBranch::SpecificBranch,
      description: "Resolver to Fetch a specific Branch"
    field :allBranches, resolver: Resolvers::CustomerBranch::AllBranches,
      description: "Resolver to Fetch all Branches of a customer"
    field :activeBranches, resolver: Resolvers::CustomerBranch::ActiveBranches,
      description: "Resolver to Fetch all the Branches of a customer which are active"

    # QUERY FOR DRIVER
    field :driver, resolver: Resolvers::Driver::SpecificDriver,
     description: "Resolver for Specific Driver "
    field :alldrivers, resolver: Resolvers::Driver::AllDrivers,
     description: "Resolver for all Driver in an Group "
    field :StatusEnum, resolver: Resolvers::Driver::DriverStatus,
     description: "Retrive all the status available for driver"
    field :active_drivers, resolver: Resolvers::Driver::ActiveDrivers,
     description: "Retrive all active drivers"

    # QUERY FOR DELIVERY Order
    field :deliveryorder, resolver: Resolvers::DeliveryOrder::SpecificDeliveryOrder,
      description: "Resolver for Specific Delivery Order"
    field :alldeliveryorder, resolver: Resolvers::DeliveryOrder::AllDeliveryOrder,
      description: "Resolver for All Delivery Order of a group"
    field :delivery_status, resolver: Resolvers::DeliveryOrder::DeliveryStatusEnum,
      description: "Resolver for delivery status of Delivery rder"

    # QUERY FOR ORDER_GROUP
    field :all_order_group, resolver: Resolvers::OrderGroups::AllOrderGroup,
      description: "Resolver to fetch all order_groups"
    field :specific_order_group, resolver: Resolvers::OrderGroups::SpecificOrderGroup,
      description: "Resolver to fetch specific order group"
    field :unit, resolver: Resolvers::OrderGroups::UnitResolver,
      description: "Resolver to fetch unit."
    field :frequency, resolver: Resolvers::OrderGroups::RecurrenceFrequenciesResolver,
      description: "Resolver to fetch frequncy"

    # QUERY FOR CATEGORY
    field :all_category, resolver: Resolvers::Category::AllCategory,
      description: "Resolver to fetch all categories"
    field :specific_category, resolver: Resolvers::Category::SpecificCategory,
      description: "Resovler to fetch specific order_group"

    # QUERY FOR LINEITEMS
    field :specific_line_item, resolver: Resolvers::LineItem::LineItemResolver,
      description: "Resolver to featch line items"

    # QUERY FOR CSV
    field :csv_export, resolver: Resolvers::Csv::CsvExportResolver,
      description: "Resolver to download csv file for a particular customer"
  end
end
