require './lib/headers'
body = Nokogiri.HTML(content)
products = body.css(".product-list-item")

scrape_url_nbr_products = body.at_css(".amount").text.strip.split("av").last.strip.to_i


products.each_with_index do |product,i|

  pages << {
      page_type: 'product_details',
      method: 'GET',
      headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
      url: product.at(".product-name").at("a").attr("href")+"?search=#{page['vars']['search_term']}",
      vars:{
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'rank' => i + 1,
          'page' => page['vars']['page']
      }

      }

end

