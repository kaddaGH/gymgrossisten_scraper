require './lib/headers'

# 1: Seed taxonomy & search pages

search_terms = [   'Energidrycker']
search_terms.take(1).each do |search_term|

  pages << {
      page_type: 'products_listing',
      method: 'GET',
      headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
      url: "https://www.gymgrossisten.com/catalogsearch/result/?q=#{search_term.gsub(' ', '+')}",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end
