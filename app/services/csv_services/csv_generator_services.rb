module CsvServices
  require "csv"
  class CsvGeneratorServices
    def initialize(customer_id)
      @customer = Customer.find_by(id: customer_id)
      @order_groups = OrderGroup.includes(:delivery_order).where(customer: @customer)
    end

    def generate_csv
      CSV.generate(headers: true) do |csv|
        csv << [ "Order Group ID",
          "Customer Name",
          "Customer Branch",
          "Delivery Order ID",
          "Status",
          "Delivery Date",
          "Dispatched Date",
          "Recurring",
          "Recurring Frequency",
          "Product",
          "Quantity",
          "Unit" ]

        @order_groups.each do |order_group|
          delivery_order = order_group.delivery_order
          csv << [
            order_group.id,
            @customer.name,
            order_group.customer_branch.branch_location,
            delivery_order.id,
            delivery_order.status,
            delivery_order.delivery_date,
            delivery_order.dispatched_date,
            order_group.recurring,
            order_group.recurrence_frequency
          ]
          delivery_order.line_items.each do |line_item|
            csv << [
              "",  # Empty for Order Group ID
              "",  # Empty for Customer Name
              "",  # Empty for Customer Branch
              "",  # Empty for Delivery Order ID
              "",  # Empty for Status
              "",  # Empty for Delivery Date
              "",  # Empty for Dispatched Date
              "",  # Empty for recurring
              "",  # Empty for recurrence_frequencey
              line_item.goods.name, # Assuming `goods` has a `name` method
              line_item.quantity,
              line_item.unit
            ]
          end
        end
      end
    end
  end
end
