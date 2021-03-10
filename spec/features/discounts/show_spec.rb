require 'rails_helper'

RSpec.describe "discount show page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount = @merchant.discounts.create!(percent: 10, threshold: 10)
  end

  describe "when i visit a discounts show page it" do
    it "shows the discount's id, percentage and threshold" do
      visit merchant_discount_path(@merchant.id, @discount.id)

      expect(page).to have_content("Discount ID##{@discount.id}")
      expect(page).to have_content("Percent: #{@discount.percent}%")
      expect(page).to have_content("Threshold: #{@discount.threshold}")
    end

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
end
