require 'rails_helper'

RSpec.describe 'Merchant Index Show Page' do
  before :each do
    @merchant_1 = Merchant.create!(name: "Larry's Lucky Ladles")
    @merchant_2 = Merchant.create!(name: "Spatula City")

    @item_1 = Item.create!(name: "Star Wars Ladle", description: "May the soup be with you", unit_price: 10, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Sparkle Ladle", description: "Serve in style", unit_price: 12, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Green Ladle", description: "It is green", unit_price: 15, merchant_id: @merchant_1.id)
    @item_4 = Item.create!(name: "Purple Ladle", description: "It is purple", unit_price: 17, merchant_id: @merchant_1.id)
    @item_5 = Item.create!(name: "Yellow Ladle", description: "It is yellow", unit_price: 14, merchant_id: @merchant_1.id)
    @item_6 = Item.create!(name: "Orange Ladle", description: "It is orange", unit_price: 20, merchant_id: @merchant_1.id)
    @item_7 = Item.create!(name: "Black Ladle", description: "It is black", unit_price: 5, merchant_id: @merchant_1.id)

    @customer_1 = Customer.create!(first_name: "Sally", last_name: "Brown")
    @customer_2 = Customer.create!(first_name: "Morgan", last_name: "Freeman")

    @invoice_1 = Invoice.create!(status: 1, customer_id: @customer_1.id)
    @invoice_2 = Invoice.create!(status: 1, customer_id: @customer_1.id)
    @invoice_3 = Invoice.create!(status: 1, customer_id: @customer_2.id)
    @invoice_4 = Invoice.create!(status: 1, customer_id: @customer_2.id)

    @ii_1 = InvoiceItem.create!(quantity: 5, unit_price: 10, status: 0, item_id: @item_1.id, invoice_id: @invoice_1.id)
    @ii_2 = InvoiceItem.create!(quantity: 5, unit_price: 12, status: 2, item_id: @item_2.id, invoice_id: @invoice_1.id)
    @ii_3 = InvoiceItem.create!(quantity: 5, unit_price: 15, status: 0, item_id: @item_3.id, invoice_id: @invoice_2.id)
    @ii_4 = InvoiceItem.create!(quantity: 5, unit_price: 17, status: 2, item_id: @item_4.id, invoice_id: @invoice_2.id)
    @ii_5 = InvoiceItem.create!(quantity: 5, unit_price: 14, status: 0, item_id: @item_5.id, invoice_id: @invoice_1.id)
    @ii_6 = InvoiceItem.create!(quantity: 5, unit_price: 20, status: 2, item_id: @item_6.id, invoice_id: @invoice_1.id)
    @ii_7 = InvoiceItem.create!(quantity: 5, unit_price: 5, status: 0, item_id: @item_7.id, invoice_id: @invoice_2.id)

    @discount_1 = BulkDiscount.create!(percentage: 0.25, threshold: 5, merchant_id: @merchant_1.id)
    @discount_2 = BulkDiscount.create!(percentage: 0.50, threshold: 15, merchant_id: @merchant_1.id)
    @discount_3  = BulkDiscount.create!(percentage: 0.60, threshold: 25, merchant_id: @merchant_1.id)
    @discount_4 = BulkDiscount.create!(percentage: 0.10, threshold: 7, merchant_id: @merchant_2.id)
  end

  it 'displays a list of a merchants discounts' do
    visit "/merchants/#{@merchant_1.id}/discounts"

    within("#discounts_list") do
      expect(page).to have_content(@discount_1.threshold)
      expect(page).to have_content((@discount_2.percentage * 100))
      expect(page).to have_content(@discount_3.threshold)
      expect(page).to_not have_content(@discount_4.threshold)
    end
  end

  it 'has a link to each discounts show page' do
    visit "/merchants/#{@merchant_1.id}/discounts"

    within("#show-#{@discount_2.id}") do
      click_link "Discount Details"
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_2.id}")
    end
  end

  it 'has a link to create a new discount' do
    visit "/merchants/#{@merchant_1.id}/discounts"

    click_link("Create New Discount")
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/new")
  end

  it 'has link to delete a discount' do
    visit "/merchants/#{@merchant_1.id}/discounts"

    expect(page).to have_content(@discount_2.threshold)

    within("#show-#{@discount_2.id}") do
      click_link "Delete Discount"
    end

    within('#discounts_list') do
      expect(page).to_not have_content(@discount_2.threshold)
    end
  end

  it 'displays the 3 nearest holidays' do
    visit "/merchants/#{@merchant_1.id}/discounts"

    within('#upcoming_holidays') do
      expect(page).to have_content("Christmas Day")
      expect(page).to have_content("New Year's Day")
      expect(page).to have_content("Thursday, Nov 25, 2021")
    end
  end
end
