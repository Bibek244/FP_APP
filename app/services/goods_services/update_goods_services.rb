
module GoodsServices
  class UpdateGoodsServices
    attr_accessor :errors, :success, :goods
    attr_reader :goods_input

    def initialize(goods_id, goods_input = {})
      @goods_input = goods_input
      @goods_id = goods_id
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
      ActiveRecord::Base.transaction do
        @goods = Goods.find_by(id: @goods_id)
        @goods.update!(@goods_input.to_h)
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
