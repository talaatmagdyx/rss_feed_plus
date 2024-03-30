require 'rss_feed'
require 'nokogiri'
require 'open-uri'

url = ['https://abcnews.go.com/abcnews/usheadlines']


def fetch_and_parse_xml(url)
  rss_data = URI.parse(url).open
  Nokogiri::XML(rss_data)
end
# p RssFeed::Parser.new(url).parse
doc = fetch_and_parse_xml(url.first)
doc = doc.at_xpath('//item')
thumbnails = doc.xpath('//media:thumbnail', 'media' => 'http://search.yahoo.com/mrss/')

thumbnails.each do |thumbnail|
  thumbnail.attributes.each do |name, value|
    puts "#{name}: #{value}"
  end
end



