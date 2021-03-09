class DiscountsController < ApplicationController


  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayProsessing.new
    @next_three = @holidays.next_three_holidays("US")
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @discount = Discount.new(discount_params)
    @discount.percent = (@discount.percent.to_f / 100)
    @discount.save

    redirect_to(merchant_discounts_path(params[:merchant_id]))
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy

    redirect_to(merchant_discounts_path(params[:merchant_id]))
  end

  private
  def discount_params
    params.permit(:percent, :threshold, :merchant_id)
  end
end
