module OrderGroupServices
  class DeleteOrderGroup
    attr_accessor :success, :errors
    attr_reader :order_group

    def initialize(order_id)
      @delete_order = order_id
      @success = false
      @errors = []
    end

    def success?
      @success
    end

    def errors
      @errors.join(", ")
    end

    def execute
      binding.irb
      call
      self
    end

    private

    def call
      binding.irb
      ActiveRecord::Base.transaction do
        @order_group = OrderGroup.find_by(id: @delete_order)
        unless @order_group
          @errors << "Order Group doesnot exist."
          raise ActiveRecord::Rollback
        else
          @order_group.destroy!
          @success = true
          @errors = []
        end
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
