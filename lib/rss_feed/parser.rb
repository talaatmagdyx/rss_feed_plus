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
      channel_info = {}
      channel_tags = channel.parse
      channel.class::TAGS.each do |tag|
        tag = tag.to_s
        value = RssFeed::Feed::Namespace.access_tag(tag, channel_tags)

        if value.present?
          clean_value = RssFeed::Feed::Namespace.remove_html_tags(value)
          channel_info[tag] = clean_value if clean_value.present?
        end
      end
      channel_info
    end

    def extract_item_info(items)
      item_info = []
      items.parse.each do |item|
        item_data = {}
        items.class::TAGS.each do |tag|
          tag = tag.to_s
          value = RssFeed::Feed::Namespace.access_tag(tag, item)
          if value.present?
            clean_value = RssFeed::Feed::Namespace.remove_html_tags(value)
            item_data[tag] = clean_value if clean_value.present?
          end
        end
        item_info << item_data
      end
      item_info
    end
  end
end
