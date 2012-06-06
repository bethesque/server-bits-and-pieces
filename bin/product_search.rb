require 'net/http'
require 'uri'
require 'config'
require 'email'

include ServerConfig

searches = {
	"MAC" => ["","Studiofix NC30", "Powerpoint stubborn", "brun"],
        "AmazingConcealer" => ["Light Golden"],
        "Amazing Concealer" => ["Light Golden"],
        "" => ["Urban Decay", "UrbanDecay"],
        }
search_urls_with_matches = {}

searches.each do | brand_name, products |
  products.each do | product |
    #search_url = "http://au.strawberrynet.com/product-search/?searchLineId=&searchField=#{URI.escape(product)}&hfAll=&BrandName=#{URI.escape(brand_name)}&all=1"
    search_url = "http://au.strawberrynet.com/product-search/?searchLineId=&searchField=#{URI.escape(brand_name + " " + product)}&hfAll=&all=1"
    res = Net::HTTP.get_response(URI.parse(search_url))
    body = res.body
    if body =~ /[123456789] results for/
      search_urls_with_matches["#{brand_name} #{product}"] = search_url
    end
  end
end

if search_urls_with_matches.any?
  search_results = search_urls_with_matches.collect{ | product_name, url | "#{product_name} #{url.gsub('beth','')}\n\n"}.join 
  puts search_results
  send_email(config.email.sender.address, "Beth's Product Search", config.email.shopping.address, "Beth", "strawberrynet.com search results", search_results)
else
  puts "No products found"
end

