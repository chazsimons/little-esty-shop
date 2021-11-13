class MerchantDiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:discount_id])
  end

  def new
  end
end
