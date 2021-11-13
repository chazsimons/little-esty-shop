require 'rails_helper'

RSpec.describe 'New Discount Form' do
  before :each do
    @merchant_1 = Merchant.create!(name: "Larry's Lucky Ladles")
    @merchant_2 = Merchant.create!(name: "Spatula City")
    @discount_1 = BulkDiscount.create!(percentage: 0.25, threshold: 5, merchant_id: @merchant_1.id)
    @discount_2 = BulkDiscount.create!(percentage: 0.50, threshold: 15, merchant_id: @merchant_1.id)
    @discount_3  = BulkDiscount.create!(percentage: 0.60, threshold: 25, merchant_id: @merchant_1.id)
    @discount_4 = BulkDiscount.create!(percentage: 0.10, threshold: 7, merchant_id: @merchant_2.id)
  end

  it 'has a form for creating a new discount' do
    visit "/merchants/#{@merchant_1.id}/discounts/new"

    within("#create_discount") do
      fill_in :percentage, with: 0.50
      fill_in :threshold, with: 25
      click_button "Create Discount"
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts")
    end
  end
end
