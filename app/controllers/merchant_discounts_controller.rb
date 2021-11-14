class MerchantDiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create!(discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  def edit
    @discount = BulkDiscount.find(params[:discount_id])
  end

  def update
    discount = BulkDiscount.find(params[:discount_id])
    discount.update(discount_params)
    redirect_to "/merchants/#{params[:merchant_id]}/discounts/#{discount.id}"
  end

  def destroy
    BulkDiscount.find(params[:discount_id]).destroy
    redirect_to "/merchants/#{params[:merchant_id]}/discounts"
  end

  private
    def discount_params
      params.permit(:percentage, :threshold, :created_at, :updated_at)
    end
end
