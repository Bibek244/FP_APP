module OrderGroupServices
  class UpdateOrderGroup
    attr_accessor :success, :errors
    attr_reader :order_group

    def initialize(order_group_id, update_order)
      @order_group_id = order_group_id
      @update_order = update_order
      @success = false
      @errors = []
    end

    def success?
      @success && @errors.empty?
    end

    def errros
      @errors.join(", ")
    end

    def execute
      call
      self
    end

    private

    def call
      ActiveRecord::Base.transaction do
        customer_branch = CustomerBranch.find_by(id: @update_order[:customer_branch_id])
        unless customer_branch
          @errors << "CustomerBranch was not found"
          raise ActiveRecord::Rollback
        end

        customer = customer_branch.customer_id
        unless customer
          @errors << "Customer was not found"
          raise ActiveRecord::Rollback
        end

        @order_group = OrderGroup.find_by(id: @order_group_id)

        unless @order_group
          @errors << "Order group was not found."
          raise ActiveRecord::Rollback
        end

        @order_group.update!(
          group_id: @update_order[:group_id],
          planned_at: @update_order[:planned_at],
          customer_id: customer,
          customer_branch: customer_branch
        )

        if @update_order[:lined_items_attributes].present?
          @update_order[:lined_items_attributes].each do |item_attributes|
            if item_attributes[:id]
              line_item = @order_group.line_items.find_by(id: item_attributes[:id])
              if line_item
                if item_attributes[:destroy] == true
                  line_item.destroy!
                else
                  if item_attributes[:goods_id].nil? || item_attributes[:quantity].nil?
                    @errors << "When not destroying, both goods_id and quantity must be provided."
                     raise ActiveRecord::Rollback
                  else
                    line_item.update!(item_attributes.except(:id))
                  end
                end
              else
                @errors << "LineItem with id #{item_attributes[:id]} not found"
              end
            else
              @order_group.line_items.create!(item_attributes)
            end
          end
        end
        @success = true
        @errors = []
      end
    rescue ActiveRecord::RecordInvalid => err
      @success = false
      @errors << err.message
    rescue => err
      @success = false
      @errors << err.message
    end
  end
end
