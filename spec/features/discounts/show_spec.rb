require 'rails_helper'

RSpec.describe "discount show page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount = @merchant.discounts.create!(percent: 10, threshold: 50)
    @discount1 = @merchant.discounts.create!(percent: 20, threshold: 10)

    @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 0)

    @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii1 = InvoiceItem.create!(invoice: @invoice1, item: @item1, quantity: 10, unit_price: 1, status: 0)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)

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

    it "does not show a delet button if a discount has pending invoice items" do
      visit merchant_discount_path(@merchant.id, @discount1.id)

      expect(page).to_not have_button("Edit")
      expect(page).to have_content("This item cannot be edited, there are pending invoices")
    end
  end
end
