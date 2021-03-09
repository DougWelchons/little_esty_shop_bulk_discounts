require 'rails_helper'

RSpec.describe "discount show page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount = @merchant.discounts.create!(percent: 0.10, threshold: 10)
  end

  describe "when i visit a discounts show page it" do
    it "shows the discount id, percentage and threshold" do
      visit merchant_discount_path(@merchant.id, @discount.id)

      expect(page).to have_content("Discount ID##{@discount.id}")
      expect(page).to have_content("Percent: #{@discount.percent * 100}%")
      expect(page).to have_content("Threshold: #{@discount.threshold}")
    end
  end
end
