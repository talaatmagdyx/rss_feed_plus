require 'nokogiri'
require 'open-uri'

require_relative 'feed/channel'
require_relative 'feed/item'
require_relative 'feed/namespace'
require_relative '../rss_feed/object'
require_relative '../rss_feed/dynamic_object'
module RssFeed
  class Parser
    attr_reader :feed_urls

    def initialize(feed_urls)
      @feed_urls = feed_urls
    end

    def parse
      document = fetch_and_parse_xml(feed_urls)
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
        tag_data = extract_tag_data(tag, feed_parse)
        next if tag_data[:text].blank? && tag_data[:nested_elements].blank? && tag_data[:nested_attributes].blank?

        items = extract_items(tag_data)
        # if tag == 'media:thumbnail'
        #   puts "items: #{items}"
        #   puts "tags: #{tag}"
        # end

        next if items.blank? && tag_data[:nested_attributes].blank?

        item_info = { 'values' => items }
        add_attributes(item_info, tag_data) # Add attributes to the item_info hash
        item_data[tag] = item_info.compact
      end

      item_data
    end

    def extract_tag_data(tag, feed_parse)
      value = RssFeed::Feed::Namespace.access_tag(tag, feed_parse)
      value[:attributes] = extract_attributes(value[:docs]) if value[:nested_attributes]
      value
    end

    def extract_items(tag_data)
      tag_data[:nested_elements] ? extract_nested_data(tag_data[:docs]) : extract_clean_value(tag_data[:text])
    end

    def add_attributes(tag_item, tag_data)
      attributes = tag_data[:attributes]
      tag_item['attributes'] = attributes if attributes.present?

    end

    def extract_clean_value(docs)
      clean_value = RssFeed::Feed::Namespace.remove_html_tags(docs)
      clean_value if clean_value.present?
    end

    def extract_nested_data(nodes)
      nodes.each_with_object({}) do |node, nested_data|
        node.children.each do |child|
          child_value = RssFeed::Feed::Namespace.remove_html_tags(child.text)
          nested_data[child.name.to_sym] = child_value if child_value.present?
        end
      end
    end

    def extract_attributes(node)
      node.map do |thumbnail|
        attributes_hash = {}
        thumbnail.attributes.each do |name, value|
          attributes_hash[name.to_s] = value.to_s
        end
        attributes_hash
      end
    end
  end
end
