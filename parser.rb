require 'rss_feed'
require 'nokogiri'
require 'open-uri'

# url = 'https://feeds.nbcnews.com/nbcnews/public/news'
# url = 'https://abcnews.go.com/abcnews/usheadlines'
url = 'https://feeds.nbcnews.com/nbcnews/public/news'
# url = 'https://www.ruby-lang.org/en/feeds/news.rss'
rss = RssFeed::Parser.new(url).parse
p rss
# def fetch_and_parse_xml(url)
#   rss_data = URI.parse(url).open
#   Nokogiri::XML(rss_data)
# end
#
# doc = fetch_and_parse_xml(url.first)
# doc = doc.at_xpath('//item')
# thumbnails = doc.xpath('//media:content', 'media' => 'http://search.yahoo.com/mrss/')
#
# thumbnails.each do |thumbnail|
#   thumbnail.attributes.each do |name, value|
#     puts "#{name}: #{value}"
#   end
# end
