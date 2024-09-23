
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
          category = Category.find_by(id: @goods_input[:category_id])

          if category.nil?
            raise ActiveRecord::RecordInvalid.new(Goods.new), "Category not found"
          end
          @goods = Goods.create!(@goods_input.to_h.except(:category_id).merge(
            category: category,
            group_id: @current_user.group_id
          ))
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
