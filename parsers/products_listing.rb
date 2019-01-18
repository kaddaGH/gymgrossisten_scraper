require './lib/headers'
body = Nokogiri.HTML(content)
products = body.search(".product-list-item")

scrape_url_nbr_products = body.at(".amount").text.strip.split("av").last.strip.to_i

products.each_with_index do |product,i|




end
