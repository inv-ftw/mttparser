class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    #binding.pry
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path, notice: 'Toвар добавлен.'
    else
      render action: :new, alert: 'Ошибка!'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(item_params)
      redirect_to items_path, notice: 'Товар обновлен.'
    else
      render action: :edit, alert: 'Ошибка!'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to items_path, notice: 'Товар удален.'
  end

  def import
    Item.import(params[:file])
    redirect_to items_path, notice: "Products imported."
  end

  private
  def item_params
    params.require(:item).permit(:name, :price, :brand, :sku)
  end

end
