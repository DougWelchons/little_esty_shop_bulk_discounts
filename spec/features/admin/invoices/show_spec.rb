require 'rails_helper'

describe 'Admin Invoices Show Page' do
  describe "when I visit the merchant show page it" do
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

    it "shows the revenue without the discount" do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content("Revenue: $356.00")
    end

    it "shows the savings to be applied" do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content("Customer Savings: $105.00")
    end

    it "shows the total revinue including discounts" do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content("Total Revenue: $251.00")
    end

    it "shows the percent discount for each item on the invoice" do
      visit "admin/invoices/#{@invoice1.id}"

      within(".table") do
        within("#the-status-#{@ii1.id}") do
          expect(page).to have_content("#{@discount1.percent}%")
        end

        within("#the-status-#{@ii2.id}") do
          expect(page).to have_content("#{@discount2.percent}%")
        end

        within("#the-status-#{@ii3.id}") do
          expect(page).to have_content("#{@discount3.percent}%")
        end

        within("#the-status-#{@ii4.id}") do
          expect(page).to have_content("#{@discount4.percent}%")
        end
      end
    end

    it "shows that 'No Discount Applied' for items that don't ahve discounts" do
      visit "admin/invoices/#{@invoice1.id}"

      within(".table") do
        within("#the-status-#{@ii6.id}") do
          expect(page).to have_content("No Discount Applied")
        end
      end
    end
  end

  describe "existing tests" do
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')

      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

      visit admin_invoice_path(@i1)
    end

    it 'should display the id, status and created_at' do
      expect(page).to have_content("Invoice ##{@i1.id}")
      expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

      expect(page).to_not have_content("Invoice ##{@i2.id}")
    end

    it 'should display the customers name and shipping address' do
      expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
      expect(page).to have_content(@c1.address)
      expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

      expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
    end

    it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_1.unit_price}")
      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content("$#{@ii_3.unit_price}")
      expect(page).to_not have_content(@ii_3.status)
    end

    it 'should display the total revenue the invoice will generate' do
      expect(page).to have_content("Total Revenue: $30.00")

      expect(page).to_not have_content(@i2.total_revenue)
    end

    it 'should have status as a select field that updates the invoices status' do
      within("#status-update-#{@i1.id}") do
        select('cancelled', :from => 'invoice[status]')
        expect(page).to have_button('Update Invoice')
        click_button 'Update Invoice'

        expect(current_path).to eq(admin_invoice_path(@i1))
        expect(@i1.status).to eq('complete')
      end
    end
  end
end
