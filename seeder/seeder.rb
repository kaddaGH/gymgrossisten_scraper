require './lib/headers'

# 1: Seed taxonomy & search pages
pages << {
    page_type: 'products_listing',
    method: 'GET',
    headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
    url: "https://www.gymgrossisten.com/kosttillskott/drycker/energidryck",
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}
search_terms = ['Red Bull', 'RedBull', 'Energidryck', 'Energidrycker']
search_terms.each do |search_term|

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
