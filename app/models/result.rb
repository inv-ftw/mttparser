class Result < ActiveRecord::Base
  require 'open-uri'
  belongs_to :item
  belongs_to :shop

  def get_results(params = {})
    shops = params[:r_shop].present? ? Shop.where(id: params[:r_shop]) : Shop.all
    items = params[:r_item].present? ? Item.where(id: params[:r_item]) : Item.all
    Result.delete_all
    items.each do |item|
      shops.each do |shop|
        begin
          base_url = shop.url
          url = base_url + CGI.escape(item.name)
          result = Result.new
          result.shop = shop
          result.item = item
          puts url
          doc = Nokogiri::HTML(open(url))
        rescue #OpenURI::HTTPError
          current_block = nil
          unless doc.nil?
            current_block = doc.at(shop.tags.item.name + ":contains('#{item.sku}')")
            current_block = doc.at(shop.tags.item.name + ":contains('#{item.name}')") if current_block.nil?
          end
          if current_block.present?
            result.current_price = current_block.at_css(shop.tags.price.name).text.to_f if current_block.at_css(shop.tags.price.name).present?
          end
        end
          result.price_diff = params[:diff]
          result.ex_rate = params[:ex_rate]
          result.save
      end
    end

    fix_results
  end


  #private

  def fix_results
    Result.where(current_price: nil).each do |result|
      begin
        current_block = nil
        url = result.shop.url + result.item.sku
        puts url
        doc = Nokogiri::HTML(open(url))
      rescue
        unless doc.nil?
          current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.sku}')")
          current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name}')") if current_block.nil?
        end
        if current_block.present?
          result.current_price = current_block.at_css(result.shop.tags.price.name).text.to_f if current_block.at_css(result.shop.tags.price.name).present?
        end
      end
      result.price_diff = Result.where.not(price_diff: nil).last.price_diff
      result.ex_rate = Result.where.not(ex_rate: nil).last.ex_rate
      result.save
    end
  end

  #handle_asynchronously :get_results

end
