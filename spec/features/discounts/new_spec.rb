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

        expect(page).to have_content("Percent can't be blank\nPercent is not a number")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount with a percent value of 0 or less" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: 0
        fill_in :threshold, with: 10
        click_button(:Create)

        expect(page).to have_content("Percent must be greater than 0")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount with a percent value greater than 100" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: 101
        fill_in :threshold, with: 10
        click_button(:Create)

        expect(page).to have_content("Percent must be less than 100")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount with a percent that is not a number" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: "hello"
        fill_in :threshold, with: 10
        click_button(:Create)

        expect(page).to have_content("Percent is not a number")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount without a threshold" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :percent, with: 20
        click_button(:Create)

        expect(page).to have_content("Threshold can't be blank\nThreshold is not a number")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount with a threshold less then 1" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :threshold, with: 0
        fill_in :percent, with: 20
        click_button(:Create)

        expect(page).to have_content("Threshold must be greater than or equal to 1")
        expect(page).to have_button(:Create)
      end
    end

    it "will not allow me to create a discount with a threshold that is not a number" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :threshold, with: "hello"
        fill_in :percent, with: 20
        click_button(:Create)

        expect(page).to have_content("Threshold is not a number")
        expect(page).to have_button(:Create)
      end
    end

    it "will maintain the entered data if the form is permaturely submitted" do
      VCR.use_cassette('nds_public_holidays') do
        visit new_merchant_discount_path(@merchant.id)

        fill_in :threshold, with: 10
        click_button(:Create)

        expect(page).to have_field(:threshold, with: 10)
        expect(page).to have_button(:Create)
      end
    end
  end
end
