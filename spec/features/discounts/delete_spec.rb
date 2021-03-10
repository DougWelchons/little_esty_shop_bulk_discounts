require 'rails_helper'

RSpec.describe "discount delete" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 1)
    @item2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant.id)
    @item3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant.id)

    @discount1 = @merchant.discounts.create!(percent: 20, threshold: 20)
    @discount2 = @merchant.discounts.create!(percent: 30, threshold: 30)
    @discount3 = @merchant.discounts.create!(percent: 40, threshold: 40)
    @discount4 = @merchant.discounts.create!(percent: 50, threshold: 50)
    @discount5 = @merchant.discounts.create!(percent: 10, threshold: 10)

    @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii1 = InvoiceItem.create!(invoice: @invoice1, item: @item1, quantity: 10, unit_price: 1, status: 0)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
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

    it "does not show a delet button if a discount has pending invoice items" do
      VCR.use_cassette('nds_public_holidays') do
        visit "/merchant/#{@merchant.id}/discounts"

        within(".discount_list") do
          within("#discount_#{@discount5.id}") do
            expect(page).to_not have_button("Delete Discount")
            expect(page).to have_content("This discount cannot be deleted. there are pending invoices.")
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
