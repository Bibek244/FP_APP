
module GoodsServices
  class DeleteGoodsServices
    attr_accessor :errors, :success, :goods
    attr_reader :goods_input

    def initialize(goods_id, current_user)
      @goods_id = goods_id
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
      @errors
    end

  private
    def call
      ActsAsTenant.current_tenant = @current_user.group
      ActiveRecord::Base.transaction do
        @goods = Goods.find_by(id: @goods_id)
        if @goods.nil?
          raise ActiveRecord::RecordNotFound,"Product not found"
        end
        @goods.destroy
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
