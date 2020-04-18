class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = Discount.all
  end

  def new
  end

  def create
    merchant = Merchant.find(current_user[:merchant_id])
    discount = merchant.discounts.create(discount_params)
    if discount.save
      flash[:success] = "Discount has been created."
      redirect_to ("/merchant/discounts")
    else
      flash[:error] = "#{discount.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
      if @discount.save
        flash[:success] = "Discount successfully updated."
        redirect_to ("/merchant/discounts")
      else
        flash[:error] = "#{@discount.errors.full_messages.to_sentence}."
        @discount.restore_attributes
        render :edit
      end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:quantity, :percentage)
  end
end
