require 'rails_helper'

RSpec.describe Discount, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)

    @discount1 = @merchant1.discounts.create!(percent: 10, threshold: 10)
    @discount2 = @merchant1.discounts.create!(percent: 30, threshold: 30)
    @discount3 = @merchant1.discounts.create!(percent: 50, threshold: 50)

    @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii1 = InvoiceItem.create!(invoice: @invoice1, item: @item1, quantity: 10, unit_price: 1, status: 0)
    @ii2 = InvoiceItem.create!(invoice: @invoice1, item: @item2, quantity: 20, unit_price: 2, status: 1)
    @ii3 = InvoiceItem.create!(invoice: @invoice1, item: @item3, quantity: 30, unit_price: 3, status: 2)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
  end

  describe "validations" do
    it {should validate_presence_of :threshold}
    it {should validate_presence_of :percent}
    it {should validate_numericality_of(:threshold).is_greater_than_or_equal_to(1)}
    it {should validate_numericality_of(:percent).is_greater_than(0)}
    it {should validate_numericality_of(:percent).is_less_than(100)}
  end

  describe "instance methods" do
    describe "#pending_invoice_items?" do
      it "returns true if any invoices useing this discount are pending" do
        expect(@discount1.pending_invoice_items?).to eq(true)
      end

      it "returns false if no invoices useing this discount are pending" do
        expect(@discount2.pending_invoice_items?).to eq(false)
      end

      it "returns false if no invoices are useing this discount" do
        expect(@discount3.pending_invoice_items?).to eq(false)
      end
    end
  end
end
