require './lib/headers'
body = Nokogiri.HTML(content)

id = body.at(".product-sku").at("b").text.strip rescue Digest::MD5.hexdigest(page[:url])
title = body.at('//meta[@property="og:title"]').attr("content") rescue nil
title ||= body.at(".product-name").text.strip
category = 'ENERGIDRYCK'
brand = body.search(".pure-g").at(".product-brand").text.strip rescue nil
brand ||= [
    'Carnation', '5-Hour Energy Shot', 'Zipfizz', 'Starbucks', 'CYRON', 'NCAA', 'Meilo', 'Chicago Bulls',
    'AMP', 'SlimFast', "Maxx", "Hell", "Powerking", "Jupí", "Oshee",
    "N-Gine", "Isostar", "Semtex", "Big Shock!", "Tiger", "Gatorade", "Pickwick", "Rauch", "Tesco",
    "Red Bull", "Nocco", "Celsius", "Wolverine", "Monster", "Vitamin Well", "Aminopro", "Powerade", "Nobe",
    "Burn", "Njie", "Boost", "Vive", "Black", "Arctic+", "Activlab", "Air Wick", "N'Gine",
    "4Move", "i4Sport", "BLACK", "Body&Future", "X-tense", "Booster", "Rockstar", "28 Black", "Adelholzener",
    "Dr. Pepper", "Topfit", "Power System", "Berocca", "Demon", "G Force", "Lucozade", "Mother", "Nos",
    "Phoenix", "Ovaltine", "Puraty", "Homegrown", "V", "Running With Bulls",
    'Liquid Ice', 'All Sport', 'Kickstart', 'Bang', 'Full Throttle', 'Lyte Ade', 'Gamergy',
    'Ax Water', 'Propel', 'Nesquick', 'Up Energy', 'Wired Energy', 'Red Elixir',
    'Body Armor', 'Rip It', 'Fitaid', 'Focusaid', 'Partyaid', 'Lifeaid', 'Kicks Start', 'Bawls',
    'Xpress', 'Core Power', 'Runa', 'Zola', 'Outlaw', 'Uptime', 'Green Dragon', 'Gas Monkey',
    'Ruckpack', 'Xing', 'Clutch', 'Chew-A-Bull', 'Matchaah', 'Surge', 'Chew A Bull', 'Vitargo',
    'Star Nutrition', 'Monster Energy', 'Nutramino Fitness Nutrition', 'Olimp Sports Nutrition',
    'Belgian Blue', 'Maxim', 'Biotech USA', 'Gainomax', 'Chained Nutrition'
].find {|brand_name| title.downcase.include?(brand_name.downcase)} || ''

description = body.at('//meta[@property="og:description"]').attr("content") rescue nil
description ||= body.at(".product-description-short").text.strip rescue ''

image_url = body.at('//meta[@property="og:image"]').attr("content") rescue nil
image_url ||= body.at(".image-gallery-preview-image").attr("src") rescue ''
price = body.search(".full-product-price").at(".price").text.gsub("kr", "").unicode_normalize(:nfkc).strip rescue nil
is_available = price.nil? ? "0" : "1"
promotion = body.search(".product-img-box").search(".ribbons").text.gsub("\n", "").gsub("\t", "").gsub("\r", "").unicode_normalize(:nfkc).strip.squish
rating = body.at(".ratings").at(".rating-box").children[1].attr("style").gsub("width:", "").strip rescue ''
review = body.at(".reviews-amount").text.scan(/\d+/).join rescue ''

item_size = nil
uom = nil
in_pack = nil
[title, description].each do |size_text|
  next unless size_text
  regexps = [
      /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
      /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
      /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
      /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
      /(\d*[\.,]?\d+)\s?([Oo]unce)/,
      /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
      /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
      /(\d*[\.,]?\d+)\s?([Ll])/,
      /(\d*[\.,]?\d+)\s?([Gg])/,
      /(\d*[\.,]?\d+)\s?([Ll]itre)/,
      /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
      /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
      /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
      /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
      /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
      /(\d*[\.,]?\d+)\s?([Cc]hews)/,
      /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
  ]
  regexps.find {|regexp| size_text =~ regexp}
  item_size = $1
  uom = $2

  break item_size, uom if item_size && uom
end

[title, description].each do |size_text|
  match = [
      /(\d+)\s?[xX]/,
      /Pack of (\d+)/,
      /Box of (\d+)/,
      /Case of (\d+)/,
      /(\d+)\s?[Cc]ount/,
      /(\d+)\s?[Cc][Tt]/,
      /(\d+)[\s-]?Pack($|[^e])/,
      /(\d+)[\s-]pack($|[^e])/,
      /(\d+)[\s-]?[Pp]ak($|[^e])/,
      /(\d+)[\s-]?Tray/,
      /(\d+)\s?[Pp][Kk]/,
      /(\d+)\s?([Ss]tuks)/i,
      /(\d+)\s?([Pp]ak)/i,
      /(\d+)\s?([Pp]ack)/i,
  ].find {|regexp| size_text =~ regexp}
  in_pack = $1

  break in_pack if in_pack
end

in_pack ||= '1'


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '0064',
    RETAILER_NAME: 'gymgrossisten',
    GEOGRAPHY_NAME: 'SE',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['SCRAPE_URL_NBR_PRODUCTS'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1: page['vars']['SCRAPE_URL_NBR_PRODUCTS'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: brand,
    PRODUCT_RANK: page['vars']['rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: id,
    PRODUCT_NAME: title,
    PRODUCT_DESCRIPTION: description,
    PRODUCT_MAIN_IMAGE_URL: image_url,
    PRODUCT_ITEM_SIZE: (item_size rescue ''),
    PRODUCT_ITEM_SIZE_UOM: (uom rescue ''),
    PRODUCT_ITEM_QTY_IN_PACK: (in_pack rescue ''),
    PRODUCT_STAR_RATING: rating,
    PRODUCT_NBR_OF_REVIEWS: review,
    SALES_PRICE: price,
    IS_AVAILABLE: is_available,
    #PROMOTION_TEXT: promotion,
    EXTRACTED_ON: Time.now.to_s
}


outputs << product_details









