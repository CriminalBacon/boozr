require 'nokogiri'
require 'mechanize'

class TescoScraper
  attr_accessor :html_doc
  attr_reader :total_items, :url

  def initialize
    @url = 'https://www.tesco.com/groceries/en-GB/shop/drinks/spirits/all?viewAll=promotion&promotion=offers&count=48'
    # agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
    @html_doc = scrape_page(@url)

    pages = @html_doc.search('.pagination__items-displayed strong').at("strong:contains('items')").parent.text
    @total_items = pages.split('of').last.split('items').first.strip!
  end

  def get_products
    products = []
    array = get_elements('.product-details--content h3 a')
    array.each do |x|
      products.append(x.text.strip)
    end
    return products
  end

  def get_prices
    prices = []
    array = get_elements('.price-per-sellable-unit--price.price-per-sellable-unit--price-per-item')
    array.each do |x|
      prices.append(x.text.partition(' ').last)
    end
    return prices
  end

  def get_products_and_prices
    puts 'scraping Tesco'
    products = get_products
    prices = get_prices

    if products.size == prices.size
      puts 'finished scraping'
      return p_and_p = products.zip(prices)
    else
      return 'Array size error encountered'
    end

  end

  private

  def scrape_page(url)
    agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
    return Nokogiri::HTML(agent.get(url).body)
    
  end 

  def get_elements(css_elements)
    values = []

    x = @total_items.to_i / 48 + 1
    (1..x).each do |i|
      page = scrape_page(@url + "&page=#{i}")
      values += page.css(css_elements)
    end

    return values
  end

end
