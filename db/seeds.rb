# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require_relative 'tesco'
require_relative 'sainsburys'

tesco = TescoScraper.new
sainsburys = SainsburyScraper.new

s_p_and_p = sainsburys.get_products_and_prices
s_p_and_p.each do |name, price|
  Product.create(store: 'S', name: name, price: price)
end

t_p_and_p = tesco.get_products_and_prices
t_p_and_p.each do |name, price|
  Product.create(store: 'T', name: name, price: price)
end
