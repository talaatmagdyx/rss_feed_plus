require 'nokogiri'
require 'open-uri'

require_relative 'feed/channel'
require_relative 'feed/item'
require_relative 'feed/namespace'
require_relative '../rss_feed/object'
module RssFeed
  class Parser
    attr_reader :feed_urls

    def initialize(feed_urls)
      @feed_urls = feed_urls
    end

    def parse
      document = fetch_and_parse_xml(feed_urls.first)
      channel = RssFeed::Feed::Channel.new(document)
      channel_info = extract_channel_info(channel)

      items = RssFeed::Feed::Item.new(document)
      item_info = extract_item_info(items)

      { 'channel' => channel_info, 'items' => item_info }
    end

    private

    def fetch_and_parse_xml(url)
      rss_data = URI.parse(url).open
      Nokogiri::XML(rss_data)
    end

    def extract_channel_info(channel)
      channel_tags = channel.parse
      extract_info(channel, channel_tags)
    end

    def extract_item_info(items)
      item_info = []
      items.parse.each do |item|
        item_info << extract_info(items, item)
      end
      item_info
    end

    def extract_info(feed, feed_parse)
      item_data = {}
      feed.class::TAGS.each do |tag|
        tag = tag.to_s
        puts "tag: #{tag}"
        value = RssFeed::Feed::Namespace.access_tag(tag, feed_parse)
        puts "value: #{value}"
        if value.present?
          clean_value = RssFeed::Feed::Namespace.remove_html_tags(value)
          puts "clean_value: #{clean_value}"
          item_data[tag] = clean_value if clean_value.present?
        end
      end
      item_data
    end
  end
end
