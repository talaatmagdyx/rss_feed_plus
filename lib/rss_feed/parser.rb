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
        value = RssFeed::Feed::Namespace.access_tag(tag, feed_parse)
        puts '===================='
        puts "value: #{value}"
        puts "tag: #{tag}"
        puts '===================='
        next unless value[:text].present?

        items = value[:nested_elements] ? extract_nested_data(value[:docs]) : extract_clean_value(value[:text])
        if items.present?
          item_data[tag] ||= {} 
          item_data[tag][:value] = items
        end
        attributes = value[:nested_attributes] ? extract_attributes(value[:docs]) : nil
        puts "====================#{attributes}====================}"
        if attributes.present?
          puts "item_data[tag]: #{item_data[tag]}"
          item_data[tag] ||= {}
          if item_data[tag]['attributes'].present?
            item_data[tag]['attributes'] + attributes
          else
            item_data[tag]['attributes'] = attributes
          end
        end
      end

      item_data
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
