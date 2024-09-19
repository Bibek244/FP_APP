
  module GoodsServices
    class CreateGoodsServices
      attr_accessor :errors, :success, :goods
      attr_reader :goods_input

      def initialize(goods_input = {}, current_user)
        @goods_input = goods_input
        @current_user = current_user
        @success = false
        @errors = []
        @goods = nil
      end

      def execute
        call
        self
      end

      def success?
        @success
      end

      def errors
        @errors.join(", ")
      end

    private
      def call
        ActsAsTenant.current_tenant = @current_user.group
        ActiveRecord::Base.transaction do
          @goods = Goods.create!(@goods_input.to_h.merge(group_id: @current_user.group_id))
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
