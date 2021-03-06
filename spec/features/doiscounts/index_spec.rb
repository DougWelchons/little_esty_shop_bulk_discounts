require 'rails_helper'

RSpec.describe "Merchant discount show page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount1 = @merchant.discounts.create!(percent: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(percent: 0.20, threshold: 20)
    @discount3 = @merchant.discounts.create!(percent: 0.30, threshold: 30)
    @discount4 = @merchant.discounts.create!(percent: 0.40, threshold: 40)
  end

  describe "when I visit a merchants dashboard it" do
    it "Has a link to view all my discounts" do
      visit "merchant/#{@merchant.id}/dashboard"

      within(".discounts") do
        expect(page).to have_link("Discounts")
      end
    end

    it "redirects to the discount show page ehwn the link is clicked" do
      visit "merchant/#{@merchant.id}/dashboard"

      click_link("Discounts")

      expect(current_path).to eq("merchants/#{@merchant.id}/discounts")
    end
  end

  describe "when I visit the Merchants discounts index page it" do
    it "shows all of my discounts, including percent and threshold" do
      visit "merchant/#{@merchant.id}/discounts"

      within(".discount_list") do
        within("#discount_#{@discount1.id}") do
          expect(page).to have_conntent(@discount1.id)
          expect(page).to have_conntent(@discount1.percent)
          expect(page).to have_conntent(@discount1.threshold)
        end

        within("#discount_#{@discount2.id}") do
          expect(page).to have_conntent(@discount2.id)
          expect(page).to have_conntent(@discount2.percent)
          expect(page).to have_conntent(@discount2.threshold)
        end

        within("#discount_#{@discount3.id}") do
          expect(page).to have_conntent(@discount3.id)
          expect(page).to have_conntent(@discount3.percent)
          expect(page).to have_conntent(@discount3.threshold)
        end

        within("#discount_#{@discount4.id}") do
          expect(page).to have_conntent(@discount4.id)
          expect(page).to have_conntent(@discount4.percent)
          expect(page).to have_conntent(@discount4.threshold)
        end
      end
    end
  end
end
