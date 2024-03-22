require 'rss_feed'

url = ['https://abcnews.go.com/abcnews/usheadlines']

p RssFeed::Parser.new(url).parse

# require 'nokogiri'
# require 'open-uri'
#
# rss_url = 'https://gorails.com/episodes.rss'
# rss_data = URI.open(rss_url)
# doc = Nokogiri::XML(rss_data)
#
# # Define namespaces
# # namespaces = {
# #   'itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd'
# # }
#
# # Retrieve itunes:author using XPath with namespace
# itunes_author = doc.at_xpath('//itunes:author')
#
# # Print the content of itunes:author element
# puts itunes_author.text if itunes_author

