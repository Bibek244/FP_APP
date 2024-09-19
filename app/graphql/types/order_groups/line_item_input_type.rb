module Types
  module OrderGroups
    class LineItemInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :goods_id, ID, required: false
      argument :quantity, Integer, required: false
      argument :destroy, Boolean, required: false
    end
  end
end
