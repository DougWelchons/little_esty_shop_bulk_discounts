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
    @discount = Discount.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to(merchant_discounts_path(params[:merchant_id]))
    else
      flash.now[:error] = @discount.errors.full_messages
      @merchant = Merchant.find(params[:merchant_id])
      render :new
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy

    redirect_to(merchant_discounts_path(params[:merchant_id]))
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to(merchant_discount_path(@discount.merchant.id, @discount.id))
    else
      flash.now[:error] = @discount.errors.full_messages
      render :edit
    end
  end

  private
  def discount_params
    params.permit(:percent, :threshold, :merchant_id)
  end

  def find_discount

  end
end
