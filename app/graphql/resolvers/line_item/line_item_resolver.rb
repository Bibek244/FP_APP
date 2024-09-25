class Resolvers::LineItem::LineItemResolver < Resolvers::BaseResolver
  type Types::LineItem::LineItemResultType, null: false

  argument :line_item_id, ID, required: true

  def resolve(line_item_id:)
    line_item = LineItem.find_by(id: line_item_id)
    if line_item.nil?
      { line_item: nil, message: nil, errors: [ "failed to fetch line_items" ] }
    else
      { line_item: line_item, message: "sucessfully fetched line items.", errors: [] }
    end
  end
end
