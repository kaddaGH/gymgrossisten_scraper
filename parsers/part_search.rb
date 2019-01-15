require './lib/headers'
# Part number search return product details page if one result found or listing of products if there is many matches
dom_html = Nokogiri.HTML(content)


product_input_details = page['vars']['product_input_details']
fetch_attempts = page['vars']['fetch_attempts']
# if it's redirection page , get the cookie and make second request
if dom_html.at_css('title').text.include?'Redirecting' and fetch_attempts<2

  headers = ReqHeaders::SEARCH_PAGE_HEADER_REQ
  headers['Cookie'] = page['response_cookie']
  pages << {
      page_type:'part_search',
      method:'GET',
      headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
      url:page['url'],
      vars: { 'product_input_details' => product_input_details , 'fetch_attempts' =>2},

  }

# If it's  products listing
elsif dom_html.at_css('#sProdList')
  dom_html.css('.sku a').each do |url|
    pages << {
        page_type: 'part_search',
        method: 'GET',
        url: url['href'],
        #headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
        fetch_type: "fullbrowser",
        vars: { 'product_input_details' => product_input_details}

    }
  end


# If it's one product details page
elsif dom_html.at_css('#product')

  product = {}


  product['Manufacturer'] = dom_html.at_css("dt:contains('Fabrikant:')").next_element.at_css('span').text.strip
  product['PartNumberWebsite'] = dom_html.at_css("dt:contains('Artikelnr. fabrikant')").next_element.text.strip
  product['QuantityOnHand'] = dom_html.at_css("p.availabilityHeading").text.tr('^0-9', '')
  product['QuantityOnOrder'] = '0'
  product['MinimumOrderQuantity'] = dom_html.at_css("span:contains('Minimum:') strong").text.strip
  product['StandardPackageQuantity'] = dom_html.at_css("span:contains('Meerdere:') strong").text.strip
  counter = 1
  dom_html.css('.data-product-pricerow-main-0').each do |price_info|
    product['Quantity' + counter.to_s] = price_info.at_css('td.qty').text.strip
    product['Price' + counter.to_s] = price_info.at_css('td.threeColTd').text.sub('€', '').strip
    counter += 1
  end
  product = product.merge(product_input_details)
  product['_collection'] = 'products'
  outputs << product


end






