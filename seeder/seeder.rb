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
