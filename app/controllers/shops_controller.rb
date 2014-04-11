class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end

  def new
    @shop = Shop.new
  end

  def create

    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: 'Магазин добавлен.'
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
      redirect_to shops_path, notice: 'Товар обновлен.'
    else
      render action: :edit, alert: 'Ошибка!'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to shops_path, notice: 'Магазин удален.'
  end

  private

  def shop_params
    params.require(:shop).permit(:id, :name, :url, tags_attributes: [:name, :_destroy, :destination, :id])
  end
end
