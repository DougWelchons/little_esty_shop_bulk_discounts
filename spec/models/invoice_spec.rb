require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item5 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item6 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @discount0 = @merchant1.discounts.create!(percent: 20, threshold: 40)
      @discount1 = @merchant1.discounts.create!(percent: 10, threshold: 10)
      @discount2 = @merchant1.discounts.create!(percent: 20, threshold: 20)
      @discount3 = @merchant1.discounts.create!(percent: 30, threshold: 30)
      @discount4 = @merchant1.discounts.create!(percent: 40, threshold: 40)

      @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii1 = InvoiceItem.create!(invoice: @invoice1, item: @item1, quantity: 10, unit_price: 1, status: 2)
      @ii2 = InvoiceItem.create!(invoice: @invoice1, item: @item2, quantity: 20, unit_price: 2, status: 2)
      @ii3 = InvoiceItem.create!(invoice: @invoice1, item: @item3, quantity: 30, unit_price: 3, status: 2)
      @ii4 = InvoiceItem.create!(invoice: @invoice1, item: @item4, quantity: 40, unit_price: 4, status: 2)
      @ii5 = InvoiceItem.create!(invoice: @invoice1, item: @item5, quantity: 10, unit_price: 5, status: 2)
      @ii6 = InvoiceItem.create!(invoice: @invoice1, item: @item6, quantity: 1, unit_price: 6, status: 2)

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
    end

    describe "instance methods" do
      it "#revenue_before_discounts" do
        expect(@invoice1.revenue_before_discounts).to eq(356)
      end

      it "#savings_amount" do
        expect(@invoice1.savings_amount).to eq(105)
      end

      it "#total_revinue" do
        expect(@invoice1.total_revenue).to eq(251)
      end
    end
  end

  describe "existing tests" do
    describe "instance methods" do
      it "total_revenue" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue).to eq(100)
      end
    end
  end
end
