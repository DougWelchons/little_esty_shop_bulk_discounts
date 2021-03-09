require 'rails_helper'

RSpec.describe "discount new page" do
  before :each do
    @merchant = Merchant.create!(name: "Name 1")
  end

  describe "when i visit the discount new page it" do
    it "shows a form to create a new discount" do
      visit new_merchant_discount_path(@merchant.id)

      expect(page).to have_field(:percent)
      expect(page).to have_field(:threshold)
      expect(page).to have_button(:Create)
    end

    it "redirects to the discount index page when the form is submitted" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: 20
        fill_in :threshold, with: 10
        click_button(:Create)

        expect(current_path).to eq("/merchant/#{@merchant.id}/discounts")
      end
    end

    it "will not allow me to create a discount without a percent value" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :threshold, with: 10
        click_button(:Create)

        expect(page).to have_content("Percent value required.")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount without a threshold" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: 20
        click_button(:Create)

        expect(page).to have_content("Threshold required.")
        expect(page).to have_button(:Create)
      end
    end
  end
end
