class Result < ActiveRecord::Base

  belongs_to :item
  belongs_to :shop

  def get_results(params = {})
    shops = params[:shop].present? ? Shop.find(params[:shop]) : Shop.all
    items = params[:item].present? ? Item.find(params[:item]) : Item.all
    Result.delete_all
    items.each do |item|
      shops.each do |shop|
        base_url = shop.url
        url = base_url + CGI.escape(item.name)
        doc = Nokogiri::HTML(open(url))
        result = Result.new
        result.shop = shop
        result.item = item

        current_block = doc.at(shop.tags.item.name + ":contains('#{item.sku}')")
        current_block = doc.at(shop.tags.item.name + ":contains('#{item.name}')") if current_block.nil?
        if current_block.present?
          result.current_price = current_block.at_css(shop.tags.price.name).text.to_f if current_block.at_css(shop.tags.price.name).present?
          result.price_diff = item.price * 13 - result.current_price if result.current_price.present?

        end
        result.save
      end
    end
  end

  def fix_results
    Result.where(current_price: nil).each do |result|
      url = result.shop.url + result.item.sku
      doc = Nokogiri::HTML(open(url))

      current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.sku}')")
      current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name}')") if current_block.nil?
      if current_block.present?
        result.current_price = current_block.at_css(result.shop.tags.price.name).text.to_f if current_block.at_css(result.shop.tags.price.name).present?
        result.price_diff = result.item.price * 13 - result.current_price if result.current_price.present?
      end
      result.save
    end
  end

  #handle_asynchronously :get_results

end
