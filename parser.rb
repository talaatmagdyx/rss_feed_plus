require 'rss_feed'
require 'nokogiri'

# require 'open-uri'
#
# # url = 'https://feeds.nbcnews.com/nbcnews/public/news'
# # url = 'https://abcnews.go.com/abcnews/usheadlines'
# url = 'https://feeds.nbcnews.com/nbcnews/public/news'
# url = 'https://www.ruby-lang.org/en/feeds/news.rss'
# rss = RssFeed::Parser.new(url).parse
# p rss

# Define your custom options
feed_urls = 'https://feeds.nbcnews.com/nbcnews/public/news'
xml_parser = Nokogiri
uri_parser = URI
timeout = 10

# Initialize the Parser class with custom options
parser = RssFeed::Parser.new(feed_urls, xml_parser: xml_parser, uri_parser: uri_parser, timeout: timeout)

# Parse the RSS feeds
# parsed_data = parser.parse

# Process the parsed data
# puts parsed_data.inspect

parsed_data = parser.parse_as_object
puts parsed_data.inspect
