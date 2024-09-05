
  module GoodsServices
    class CreateGoodsServices
      attr_accessor :errors, :success, :goods
      attr_reader :goods_input

      def initialize(goods_input = {})
        @goods_input = goods_input
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

      def call
        ActiveRecord::Base.transaction do
          @goods = Goods.create!(@goods_input.to_h)
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
