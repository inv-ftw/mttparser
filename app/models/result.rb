class Result < ActiveRecord::Base
  require 'open-uri'
  belongs_to :item
  belongs_to :shop

  # def get_results(params = {})
  #   shops = params[:r_shop].present? ? Shop.where(id: params[:r_shop]) : Shop.all
  #   items = params[:r_item].present? ? Item.where(id: params[:r_item]) : Item.all
  #   Result.delete_all
  #   items.each do |item|
  #     shops.each do |shop|
  #       puts "***shopid: #{shop.id}****itemid: #{item.id}*****************"
  #       begin
  #         base_url = shop.url
  #         url = base_url.gsub('[search_text]', CGI.escape(item.sku))
  #         result = Result.new
  #         result.shop = shop
  #         result.item = item
  #         puts url
  #         if shop.post
  #           par = shop.tags.params.name.gsub('[search_text]', CGI.escape(item.sku))
  #           doc = Nokogiri::HTML(post_open(url, par))
  #         else
  #           doc = Nokogiri::HTML(open(url))
  #         end
  #       rescue #OpenURI::HTTPError
  #         puts "***#{result.shop.id}****#{result.shop.name}**post: #{result.shop.post}*******ERROR!!!!! OpenURI!!!!!!*******************"
  #       end
  #       current_block = nil
  #
  #       if doc.present?
  #         capitalized_name = ''
  #         item.name.split(' ').each do |word|
  #           capitalized_name += word + ' '
  #         end
  #         capitalized_name.strip!
  #
  #         current_block = doc.at(shop.tags.item.name + ":contains('#{item.name + ' ' + item.sku}')")
  #         current_block = doc.at(shop.tags.item.name + ":contains('#{item.name}')") if current_block.nil?
  #         current_block = doc.at(shop.tags.item.name + ":contains('#{capitalized_name}')") if current_block.nil?
  #         current_block = doc.at(shop.tags.item.name + ":contains('#{item.sku}')") if current_block.nil?
  #       end
  #       #binding.pry
  #       if current_block.present?
  #         result.current_price = current_block.at_css(shop.tags.price.name).text.to_f if current_block.at_css(shop.tags.price.name).present?
  #         if result.current_price == 0
  #           result.current_price = current_block.at_css(shop.tags.price.name).text.gsub(/[^0-9.\\s]/i, '').to_f
  #         end
  #       end
  #       puts "*********doc: #{doc}******current_block: #{shop.id}*********************"
  #
  #       result.price_diff = params[:diff]
  #         result.ex_rate = params[:ex_rate]
  #         result.save
  #     end
  #   end
  #
  #   fix_results
  # end
  #
  #
  # #private
  #
  # def fix_results
  #   Result.where(current_price: nil).each do |result|
  #     begin
  #       current_block = nil
  #       url = result.shop.url.gsub('[search_text]', CGI.escape(result.item.name))
  #       puts url
  #       if result.shop.post
  #         par = result.shop.tags.params.name.gsub('[search_text]', CGI.escape(result.item.name))
  #         doc = Nokogiri::HTML(post_open(url, par))
  #       else
  #         doc = Nokogiri::HTML(open(url))
  #       end
  #     rescue
  #       puts "*******#{result.shop.name}**post: #{result.shop.post}*******ERROR!!!!! OpenURI!!!!!!*******************"
  #     end
  #
  #     if doc.present?
  #       capitalized_name = ''
  #       result.item.name.split(' ').each do |word|
  #         capitalized_name += word + ' '
  #       end
  #       capitalized_name.strip!
  #
  #       current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name + ' ' + result.item.sku}')")
  #       current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name}')") if current_block.nil?
  #       current_block = doc.at(result.shop.tags.item.name + ":contains('#{capitalized_name}')") if current_block.nil?
  #       current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.sku}')") if current_block.nil?
  #     end
  #     if current_block.present?
  #       result.current_price = current_block.at_css(result.shop.tags.price.name).text.to_f if current_block.at_css(result.shop.tags.price.name).present?
  #       if result.current_price == 0
  #         result.current_price = current_block.at_css(result.shop.tags.price.name).text.gsub(/[^0-9.\\s]/i, '').to_f
  #       end
  #     end
  #     result.price_diff = Result.where.not(price_diff: nil).last.price_diff
  #     result.ex_rate = Result.where.not(ex_rate: nil).last.ex_rate
  #     result.save
  #   end
  # end
  #
  #
  # def post_open(url, params)
  #   res = Net::HTTP.post_form(URI(url), post_params_to_hash(params))
  #   res.body
  # end
  #
  # def post_params_to_hash(params)
  #   hash = {}
  #   params.split('&').each do |pair|
  #     key,value = pair.split(/=/)
  #     hash[key] = value
  #   end
  #
  #   hash
  # end

end
