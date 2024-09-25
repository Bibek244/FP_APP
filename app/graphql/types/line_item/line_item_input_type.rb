module Types
  module LineItem
    class LineItemInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :goods_id, ID, required: true
      argument :quantity, Integer, required: true
      argument :unit, Types::OrderGroups::UnitEnum, required: true
      argument :destroy, Boolean, required: false
    end
  end
end
