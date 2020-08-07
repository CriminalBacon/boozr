require 'nokogiri'
require 'mechanize'

class WaitroseScraper
  attr_accessor :html_doc

  def initialize
    url = 'https://www.waitrose.com/ecom/shop/browse/offers/beer_wine_and_spirits_offers/spirits_and_liqueurs_offers?categoryId=300473'
    agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
    temp_doc = Nokogiri::HTML(agent.get(url).body)
    load_more = temp_doc.at('.button___2UT_5')
    @html_doc = Nokogiri::HTML(agent.click(load_more).body)

  end

  def get_products
    products = []
    


    array = @html_doc.css('.name___CmYia')
  end

end


scrape = WaitroseScraper.new
puts scrape.get_products

