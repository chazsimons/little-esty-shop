require 'rails_helper'

RSpec.describe 'Admin Merchant Show Page' do
  before :each do
    @merchant_1 = Merchant.create!(name: "Larry's Lucky Ladles")
    @merchant_2 = Merchant.create!(name: "Bob's Burgers")
  end

  it 'can display a single merchants information' do
    visit "/admin/merchants/#{@merchant_1.id}"

    expect(page).to have_content(@merchant_1.name)
    expect(page).to_not have_content(@merchant_2.name)
  end

  it 'has a link to a form to update the merchants information' do
    visit "/admin/merchants/#{@merchant_1.id}"

    click_link("Update Merchant Information")

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}/edit")
  end
end