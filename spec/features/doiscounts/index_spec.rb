require 'rails_helper'

RSpec.describe "Merchant discount index page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount1 = @merchant.discounts.create!(percent: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(percent: 0.20, threshold: 20)
    @discount3 = @merchant.discounts.create!(percent: 0.30, threshold: 30)
    @discount4 = @merchant.discounts.create!(percent: 0.40, threshold: 40)
  end

  describe "when I visit a merchants dashboard it" do
    it "Has a link to view all my discounts" do
      VCR.use_cassette('nds_public_holidays') do

        visit "merchant/#{@merchant.id}/dashboard"

        within(".navbar-nav") do
          expect(page).to have_link("Discounts")
        end
      end
    end

    it "redirects to the discount show page when the link is clicked" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/dashboard"

        click_link("Discounts")

        expect(current_path).to eq("/merchant/#{@merchant.id}/discounts")
      end
    end
  end

  describe "when I visit the Merchants discounts index page it" do
    it "shows all of my discounts, including percent and threshold" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/discounts"

        within(".discount_list") do
          within("#discount_#{@discount1.id}") do
            expect(page).to have_link("ID##{@discount1.id}")
            expect(page).to have_content("10%")
            expect(page).to have_content(@discount1.threshold)
          end

          within("#discount_#{@discount2.id}") do
            expect(page).to have_link("ID##{@discount2.id}")
            expect(page).to have_content("20%")
            expect(page).to have_content(@discount2.threshold)
          end

          within("#discount_#{@discount3.id}") do
            expect(page).to have_link("ID##{@discount3.id}")
            expect(page).to have_content("30%")
            expect(page).to have_content(@discount3.threshold)
          end

          within("#discount_#{@discount4.id}") do
            expect(page).to have_link("ID##{@discount4.id}")
            expect(page).to have_content("40%")
            expect(page).to have_content(@discount4.threshold)
          end
        end
      end
    end

    it "takes me to the discount show page when the link is clicked" do
      VCR.use_cassette('nds_public_holidays') do
        visit "/merchant/#{@merchant.id}/discounts"

        click_link("ID##{@discount1.id}")

        expect(current_path).to eq(merchant_discount_path(@merchant.id, @discount1.id))
      end
    end

    it "shows a headder for upcoming holidays" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/discounts"

        within(".holidays") do
          expect(page).to have_content("Upcoming Holidays")
        end
      end
    end

    it "shows the next three holidays" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/discounts"

        within(".holidays") do
          expect(page).to have_content("Memorial Day")
          expect(page).to have_content("2021-05-31")
          expect(page).to have_content("Independence Day")
          expect(page).to have_content("2021-07-05")
          expect(page).to have_content("Labor Day")
          expect(page).to have_content("2021-09-06")
        end
      end
    end

    it "shows a button to create a new discount" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/discounts"

        expect(page).to have_button("Create Discount")
      end
    end

    it "redirects to the discount new page with the create discount button is clicked" do
      VCR.use_cassette('nds_public_holidays') do
        visit "merchant/#{@merchant.id}/discounts"

        click_button("Create Discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/discounts/new")
      end
    end
  end
end
