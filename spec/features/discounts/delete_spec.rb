require 'rails_helper'

RSpec.describe "discount delete" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount1 = @merchant.discounts.create!(percent: 10, threshold: 10)
    @discount2 = @merchant.discounts.create!(percent: 20, threshold: 20)
    @discount3 = @merchant.discounts.create!(percent: 30, threshold: 30)
    @discount4 = @merchant.discounts.create!(percent: 40, threshold: 40)
  end

  describe "When i visit the discount index page it" do
    it "shows a button to delete each discount" do
      VCR.use_cassette('nds_public_holidays') do
        visit "/merchant/#{@merchant.id}/discounts"

        within(".discount_list") do
          within("#discount_#{@discount1.id}") do
            expect(page).to have_button("Delete Discount")
          end

          within("#discount_#{@discount2.id}") do
            expect(page).to have_button("Delete Discount")
          end

          within("#discount_#{@discount3.id}") do
            expect(page).to have_button("Delete Discount")
          end

          within("#discount_#{@discount4.id}") do
            expect(page).to have_button("Delete Discount")
          end
        end
      end
    end
  end

  describe "when a discounts Delete Discount button is clicked it" do
    it "redirects back to the index page and the discount is remove" do
      VCR.use_cassette('nds_delete') do
        visit "/merchant/#{@merchant.id}/discounts"

        within("#discount_#{@discount1.id}") do
          click_button("Delete Discount")
        end

        expect(current_path).to eq("/merchant/#{@merchant.id}/discounts")
        expect(page).to_not have_link("ID##{@discount1.id}")
      end
    end
  end
end
