module Types
  module LineItem
    class LineItemResultType < Types::BaseObject
      field :line_item, LineItemType, null: true
      field :errors, [ String ], null: false
      field :message, String, null: true
    end
  end
end
