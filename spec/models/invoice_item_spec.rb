require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

      @discount0 = @merchant1.discounts.create!(percent: 20, threshold: 30)
      @discount1 = @merchant1.discounts.create!(percent: 10, threshold: 10)
      @discount2 = @merchant1.discounts.create!(percent: 20, threshold: 20)
      @discount3 = @merchant1.discounts.create!(percent: 30, threshold: 30)
      @discount4 = @merchant1.discounts.create!(percent: 40, threshold: 40)

      @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii1 = InvoiceItem.create!(invoice: @invoice1, item: @item1, quantity: 30, unit_price: 1, status: 2)
    end

    it "#valid_discount" do
      expect(@ii1.valid_discount).to eq(@discount3)
    end

    it "#revinue" do
      expect(@ii1.revenue).to eq(21)
    end
  end
end
