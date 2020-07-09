require 'nokogiri'
require 'mechanize'

class SainsburyScraper
  attr_accessor :html_doc

  def initialize
    url = 'https://www.sainsburys.co.uk/webapp/wcs/stores/servlet/gb/groceries/drinks/CategoryDisplay?langId=44&storeId=10151&catalogId=10241&categoryId=458359&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&beginIndex=0&facet=88&promotionId=&listId=&searchTerm=&hasPreviousOrder=&previousOrderId=&categoryFacetId1=&categoryFacetId2=&ImportedProductsCount=&ImportedStoreName=&ImportedSupermarket=&bundleId=&parent_category_rn=12192&top_category=12192&pageSize=120#langId=44&storeId=10151&catalogId=10241&categoryId=458359&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&facet=88'
    agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
    @html_doc = Nokogiri::HTML(agent.get(url).body)
  end

  def get_products
    products = []
    array = @html_doc.css('.productNameAndPromotions h3 a')
    array.each do |x|
      products.append(x.text.strip)
    end

    return products
  end

  def get_prices
    prices = []

    product_prices = @html_doc.css('.pricingAndTrolleyOptions')
    array = product_prices.css('.pricePerUnit')
    array.each do |x|
      prices.append(x.text.split('£').last.split('/').first)
    end
    
    return prices
  end

  def get_products_and_prices
    products = get_products
    prices = get_prices

    if products.size == prices.size
      return products.zip(prices)
    else
      return 'Array size error encountered'
    end
  end

end

scrape = SainsburyScraper.new
puts scrape.get_products_and_prices[1]
