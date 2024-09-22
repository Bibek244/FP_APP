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

        customer = customer_branch.customer
        unless customer
          @errors << "Customer was not found"
          raise ActiveRecord::Rollback
        end

        @order_group = OrderGroup.find_by(id: @order_group_id)
        unless @order_group
          @errors << "Order group was not found."
          raise ActiveRecord::Rollback
        end

        if @order_group.parent_order_group.nil?
          update_order_group(@order_group, customer, customer_branch)
          update_child_order_groups(@order_group)
        else
          update_order_group(@order_group, customer, customer_branch)
        end

        @success = true
        @errors = []
      end
    rescue ActiveRecord::RecordInvalid => err
      @success = false
      @errors << err.message
    rescue ActiveRecord::Rollback
    rescue => err
      @success = false
      @errors << err.message
    end

    def update_order_group(order_group, customer, customer_branch)
      if order_group.parent_order_group
        order_group.update!(skip_update: true)
      end
      update_attributes = {}

      update_attributes[:group_id] = @update_order[:group_id] if @update_order[:group_id].present?
      update_attributes[:planned_at] = @update_order[:planned_at] if @update_order[:planned_at].present?
      update_attributes[:customer_id] = customer.id if customer.present?
      update_attributes[:customer_branch_id] = customer_branch.id if customer_branch.present?

      order_group.update!(update_attributes)

      update_line_items(order_group)
    end

    def update_child_order_groups(parent_order_group)
      parent_order_group.child_order_groups.each do |child_order_group|
        next if child_order_group.skip_update
        update_attributes = {}

        update_attributes[:planned_at] = @update_order[:planned_at] if @update_order[:planned_at].present?
        update_attributes[:customer_id] = parent_order_group.customer_id if @update_order[:customer_branch_id].present?
        update_attributes[:customer_branch_id] = parent_order_group.customer_branch_id if @update_order[:customer_branch_id].present?

        child_order_group.update!(update_attributes)
        update_line_items(child_order_group)
      end
    end

    def update_line_items(order_group)
      @update_order[:lined_items_attributes].each do |item_attributes|
        if item_attributes[:id]
          line_item = order_group.line_items.find_by(id: item_attributes[:id])
          if line_item
            if item_attributes[:destroy] == true
              line_item.destroy!
            else
              validate_line_item_attributes!(item_attributes)
              line_item.update!(item_attributes.except(:id))
            end
          else
            @errors << "LineItem with id #{item_attributes[:id]} not found"
            raise ActiveRecord::Rollback
          end
        else
          validate_line_item_attributes!(item_attributes)
          order_group.line_items.create!(item_attributes)
        end
      end
    end

    def validate_line_item_attributes!(item_attributes)
      if item_attributes[:goods_id].nil? || item_attributes[:quantity].nil?
        @errors << "Both goods_id and quantity must be provided."
        raise ActiveRecord::Rollback
      end
    end
  end
end
