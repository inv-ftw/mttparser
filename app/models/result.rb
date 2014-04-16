class Result < ActiveRecord::Base

  belongs_to :item
  belongs_to :shop

  def get_results
    Shop.all.each do |shop|
      base_url = shop.url
      Item.all.each do |item|
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
  #handle_asynchronously :get_results

end
