require 'rails_helper'

RSpec.describe "Discount edit page" do
  before :each do
    @merchant = Merchant.create!(name: "Merchant", status: 0)

    @discount = @merchant.discounts.create!(percent: 20, threshold: 10)
  end

  describe "when I visit the discount edit page it" do
    it "shows a form with the current discont information" do
      visit edit_merchant_discount_path(@merchant.id, @discount.id)

      expect(page).to have_field(:percent, with: 20)
      expect(page).to have_field(:threshold, with: 10)
      expect(page).to have_button(:Update)
    end

    it "redirects me to the discount show page whe update is clicked" do
      visit edit_merchant_discount_path(@merchant.id, @discount.id)

      fill_in :percent, with: 25
      click_button(:Update)

      expect(current_path).to eq(merchant_discount_path(@merchant.id, @discount.id))

      expect(page).to have_content("Discount ID##{@discount.id}")
      expect(page).to have_content("Percent: 25%")
      expect(page).to have_content("Threshold: #{@discount.threshold}")
    end
  end

  it "will not allow me to update a discount without a threshold" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :threshold, with: ""
    click_button(:Update)

    expect(page).to have_content("Threshold can't be blank\nThreshold is not a number")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount with a threshold of 0 or less" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :threshold, with: 0
    click_button(:Update)

    expect(page).to have_content("Threshold must be greater than or equal to 1")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount with a threshold that is not a number" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :threshold, with: "hello"
    click_button(:Update)

    expect(page).to have_content("Threshold is not a number")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount without a percent value" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :percent, with: ""
    click_button(:Update)

    expect(page).to have_content("Percent can't be blank")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount with a percent value of 0 or less" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :percent, with: 0
    click_button(:Update)

    expect(page).to have_content("Percent must be greater than 0")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount with a percent value grater then 100" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :percent, with: 101
    click_button(:Update)

    expect(page).to have_content("Percent must be less than 100")
    expect(page).to have_button(:Update)
  end

  it "will not allow me to update a discount with a percent value that is not a number" do
    visit edit_merchant_discount_path(@merchant.id, @discount.id)

    fill_in :percent, with: "hello"
    click_button(:Update)

    expect(page).to have_content("Percent is not a number")
    expect(page).to have_button(:Update)
  end
end
