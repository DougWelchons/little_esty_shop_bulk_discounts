require 'rails_helper'

RSpec.describe "Discount edit page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount = @merchant.discounts.create!(percent: 0.20, threshold: 10)
  end

  describe "When I visit a discount show page it" do
    it "shows a button to update the discount" do
      visit merchant_discount_path(@merchant.id, @discount.id)

      expect(page).to have_button("Edit")
    end

    it "redirects to the discount edit page when theedit button is clicked" do
      visit merchant_discount_path(@merchant.id, @discount.id)

      click_button("Edit")

      expect(current_path).to eq(edit_merchant_discount_path(@merchant.id, @discount.id))
    end
  end

  describe "when i visit the discount edit page it" do
    it "shows a form with the current discont information" do
      visit edit_merchant_discount_path(@merchant.id, @discount.id)

      expect(page).to have_field(:percent, with: 20)
      expect(page).to have_field(:threshold, with: 10)
      expect(page).to have_button(:Update)
    end

    it "redirects me to the discount show page whe update is clicked" do
      visit edit_merchant_discount_path(@merchant.id, @discount.id)

      fill_in :percent, with: 25
      click_button(:Update)

      expect(current_path).to eq(merchant_discount_path(@merchant.id, @discount.id))

      expect(page).to have_content("Discount ID##{@discount.id}")
      expect(page).to have_content("Percent: 25.0%")
      expect(page).to have_content("Threshold: #{@discount.threshold}")
    end
  end
end
