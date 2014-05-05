require 'open-uri'
require 'net/http'


desc 'Search prices'
task :get_results => :environment do
File.open("#{Rails.root}/log/rake.log", 'w') do |f|
  f.puts "-------Time: #{Time.now}\n\n"
  shops = ENV['R_SHOP'].present? ? Shop.where(id: ENV['R_SHOP']) : Shop.all
  items_sku = ENV['R_ITEM'].split(';').reject{|element| element.strip.length == 0}.map{|el| get_items[el]}

  f.puts items_sku.inspect
  items = items_sku.present? ? Item.where(sku: items_sku) : Item.all
  f.puts "items count: #{items.count}\n"
  f.puts ' --- \n'
  items.each do |item|
    shops.each do |shop|
      f.puts "***shopid: #{shop.id}****itemid: #{item.id}*****************"
      begin
        base_url = shop.url
        url = base_url.gsub('[search_text]', CGI.escape(item.sku))
        result = Result.new
        result.shop = shop
        result.item = item
        f.puts url
        if shop.post
          par = shop.tags.params.name.gsub('[search_text]', CGI.escape(item.sku))
          doc = Nokogiri::HTML(post_open(url, par))
        else
          doc = Nokogiri::HTML(open(url))
        end
      rescue #OpenURI::HTTPError
        f.puts "***#{result.shop.id}****#{result.shop.name}**post: #{result.shop.post}*******ERROR!!!!! OpenURI!!!!!!*******************"
      end
      current_block = nil

      if doc.present?
        capitalized_name = ''
        item.name.split(' ').each do |word|
          capitalized_name += word + ' '
        end
        capitalized_name.strip!

        current_block = doc.at(shop.tags.item.name + ":contains('#{item.name + ' ' + item.sku}')")
        current_block = doc.at(shop.tags.item.name + ":contains('#{item.name}')") if current_block.nil?
        current_block = doc.at(shop.tags.item.name + ":contains('#{capitalized_name}')") if current_block.nil?
        current_block = doc.at(shop.tags.item.name + ":contains('#{item.sku}')") if current_block.nil?
      end
      #binding.pry
      if current_block.present?
        result.current_price = current_block.at_css(shop.tags.price.name).text.gsub(',', '').to_f if current_block.at_css(shop.tags.price.name).present?
        if result.current_price == 0
          result.current_price = current_block.at_css(shop.tags.price.name).text.gsub(/[^0-9.\\s]/i, '').to_f
        end
      end
      f.puts "*********doc: #{doc.present?}******current_block: #{current_block.present?}*********************"

      result.price_diff = ENV['DIFF']
      result.ex_rate = ENV['EX_RATE']
      result.save
    end
  end

  fix_results(f)
end
end



def fix_results(f)
  Result.where(current_price: nil).each do |result|
    f.puts "***shopid: #{result.shop.id}****itemid: #{result.item.id}*****************"
    begin
      current_block = nil
      url = result.shop.url.gsub('[search_text]', CGI.escape(result.item.name))
      f.puts url
      if result.shop.post
        par = result.shop.tags.params.name.gsub('[search_text]', CGI.escape(result.item.name))
        doc = Nokogiri::HTML(post_open(url, par))
      else
        doc = Nokogiri::HTML(open(url))
      end
    rescue
      f.puts "***#{result.shop.id}****#{result.shop.name}**post: #{result.shop.post}*******ERROR!!!!! OpenURI!!!!!!*******************"
    end

    if doc.present?
      capitalized_name = ''
      result.item.name.split(' ').each do |word|
        capitalized_name += word + ' '
      end
      capitalized_name.strip!

      current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name + ' ' + result.item.sku}')")
      current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.name}')") if current_block.nil?
      current_block = doc.at(result.shop.tags.item.name + ":contains('#{capitalized_name}')") if current_block.nil?
      current_block = doc.at(result.shop.tags.item.name + ":contains('#{result.item.sku}')") if current_block.nil?
    end
    if current_block.present?
      result.current_price = current_block.at_css(result.shop.tags.price.name).text.to_f if current_block.at_css(result.shop.tags.price.name).present?
      if result.current_price == 0
        result.current_price = current_block.at_css(result.shop.tags.price.name).text.gsub(/[^0-9.\\s]/i, '').to_f
      end
    end
    f.puts "*********doc: #{doc.present?}******current_block: #{current_block.present?}*********************"

    result.price_diff = Result.where.not(price_diff: nil).last.price_diff
    result.ex_rate = Result.where.not(ex_rate: nil).last.ex_rate
    result.save
  end
end


def post_open(url, params)
  res = Net::HTTP.post_form(URI(url), post_params_to_hash(params))
  res.body
end

def post_params_to_hash(params)
  hash = {}
  params.split('&').each do |pair|
    key,value = pair.split(/=/)
    hash[key] = value
  end

  hash
end

def get_items
  Item.all.to_a.each_with_object({}){ |c,h| h[c.name + ' ' + c.sku] = c.sku }
end
