class ShopsController < ApplicationController
  def index
    @shops = Shop.all.order(:name)
  end

  def new
    @shop = Shop.new
  end

  def create

    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: "Магазин \"#{@shop.name}\" добавлен."
    else
      render action: :new, alert: 'Ошибка!'
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    #binding.pry
    if @shop.update_attributes(shop_params)
      redirect_to shops_path, notice: "Магазин \"#{@shop.name}\" обновлен."
    else
      render action: :edit, alert: 'Ошибка!'
    end
  end

  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy
    redirect_to shops_path, notice: "Магазин \"#{@shop.name}\" удален."
  end

  private

  def shop_params
    params.require(:shop).permit(:id, :name, :url, :post, tags_attributes: [:name, :_destroy, :destination, :id])
  end
end
