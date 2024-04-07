require 'nokogiri'
require 'open-uri'
require 'socket'

require_relative 'feed/channel'
require_relative 'feed/item'
require_relative 'feed/namespace'
require_relative '../rss_feed/object'
require_relative '../rss_feed/dynamic_object'

module RssFeed
  # The Parser class is responsible for parsing RSS feeds.
  class Parser
    attr_reader :feed_urls, :xml_parser, :uri_parser

    # Initialize the Parser with a list of feed URLs.
    #
    # @param feed_urls String The URLs of the RSS feeds to parse.
    def initialize(feed_urls, options = {})
      @feed_urls = feed_urls
      @xml_parser = options.fetch(:xml_parser, Nokogiri)
      @uri_parser = options.fetch(:uri_parser, URI)
      @timeout = options.fetch(:timeout, 10) # Default timeout: 10 seconds
      @logger = options[:logger]
    end

    # Parse the RSS feeds and extract channel and item information.
    #
    # @return [Hash] The parsed channel and item information.
    def parse
      document = fetch_and_parse_xml(feed_urls)
      channel = RssFeed::Feed::Channel.new(document)
      channel_info = extract_channel_info(channel)

      items = RssFeed::Feed::Item.new(document)
      item_info = extract_item_info(items)

      { 'channel' => channel_info, 'items' => item_info }
    end

    private

    # Fetch and parse XML data from the given URL.
    #
    # @param url [String] The URL of the XML data.
    # @return [Nokogiri::XML::Document] The parsed XML document.
    # def fetch_and_parse_xml(url)
    #   rss_data = uri_parser.parse(url).open
    #   @xml_parser::XML(rss_data)
    # rescue StandardError => e
    #   handle_error(e)
    #   raise RssFetchError, "Failed to fetch or parse XML: #{e.message}"
    # end
    def fetch_and_parse_xml(url)
      rss_data = URI.parse(url).open(**uri_options)
      @xml_parser::XML(rss_data)
    rescue SocketError, URI::InvalidURIError => e
      raise RssFetchError, "Failed to fetch or parse XML: #{e.message}"
    rescue Timeout::Error => e
      raise RssFetchError, "HTTP request timed out: #{e.message}"
    end

    def uri_options
      { open_timeout: @timeout, read_timeout: @timeout }.compact
    end



    # Extract channel information from the parsed XML document.
    #
    # @param channel [RssFeed::Feed::Channel] The channel object.
    # @return [Hash] The extracted channel information.
    def extract_channel_info(channel)
      extract_info(channel, channel.parse)
    end

    # Extract item information from the parsed XML document.
    #
    # @param items [RssFeed::Feed::Item] The items object.
    # @return [Array<Hash>] The extracted item information.
    def extract_item_info(items)
      items.parse.map { |item| extract_info(items, item) }
    end

    # Extract information from the XML document based on specified tags.
    #
    # @param feed [RssFeed::Feed::Channel/RssFeed::Feed::Item] The feed object.
    # @param feed_parse [Hash] The parsed XML data.
    # @return [Hash] The extracted information.
    def extract_info(feed, feed_parse)
      item_data = {}

      feed.class::TAGS.each do |tag|
        tag_data = extract_tag_data(tag, feed_parse)
        next if skip_extraction?(tag_data)

        items = extract_items(tag_data)
        next if skip_items?(items, tag_data[:nested_attributes])

        item_data[tag] = create_item_info(items, tag_data)
      end

      item_data
    end

    # Check if extraction of tag data should be skipped.
    #
    # @param tag_data [Hash] The tag data.
    # @return [Boolean] True if extraction should be skipped, otherwise false.
    def skip_extraction?(tag_data)
      tag_data.values_at(:text, :nested_elements, :nested_attributes).all?(&:blank?)
    end

    # Check if extraction of items should be skipped.
    #
    # @param items [Object] The items to check.
    # @param nested_attributes [Boolean] Whether the items have nested attributes.
    # @return [Boolean] True if extraction should be skipped, otherwise false.
    def skip_items?(items, nested_attributes)
      items.blank? && nested_attributes.blank?
    end

    # Create item information hash.
    #
    # @param items [Object] The items data.
    # @param tag_data [Hash] The tag data.
    # @return [Hash] The item information.
    def create_item_info(items, tag_data)
      { 'values' => items, 'attributes' => tag_data[:attributes] }.compact
    end

    # Extract tag data from the XML document.
    #
    # @param tag [String] The tag to extract.
    # @param feed_parse [Hash] The parsed XML data.
    # @return [Hash] The extracted tag data.
    def extract_tag_data(tag, feed_parse)
      value = RssFeed::Feed::Namespace.access_tag(tag, feed_parse)
      value[:attributes] = extract_attributes(value[:docs]) if value[:nested_attributes]
      value
    end

    # Extract items from the XML document.
    #
    # @param tag_data [Hash] The tag data.
    # @return [Object] The extracted items.
    def extract_items(tag_data)
      tag_data[:nested_elements] ? extract_nested_data(tag_data[:docs]) : extract_clean_value(tag_data[:text])
    end

    # Add attributes to the item information hash.
    #
    # @param tag_item [Hash] The item information hash.
    # @param tag_data [Hash] The tag data.
    def add_attributes(tag_item, tag_data)
      tag_item['attributes'] = tag_data[:attributes] if tag_data[:attributes].present?
    end

    # Extract clean value from the XML document.
    #
    # @param docs [Object] The XML document.
    # @return [String] The extracted clean value.
    def extract_clean_value(docs)
      RssFeed::Feed::Namespace.remove_html_tags(docs).presence
    end

    # Extract nested data from the XML document.
    #
    # @param nodes [Object] The XML nodes.
    # @return [Hash] The extracted nested data.
    def extract_nested_data(nodes)
      nodes.each_with_object({}) do |node, nested_data|
        node.children.each do |child|
          child_value = RssFeed::Feed::Namespace.remove_html_tags(child.text)
          nested_data[child.name.to_sym] = child_value if child_value.present?
        end
      end
    end

    # Extract attributes from the XML document.
    #
    # @param node [Object] The XML node.
    # @return [Array<Hash>] The extracted attributes.
    def extract_attributes(node)
      node.map do |thumbnail|
        attributes_hash = {}
        thumbnail.attributes.each do |name, value|
          attributes_hash[name.to_s] = value.to_s
        end
        attributes_hash
      end
    end

    def handle_error(error)
      error_message = "Error occurred: #{error.message}"
      @logger.present? ? @logger.error(error_message) : puts(error_message) # Fallback to puts if logger is not configured
    end

    def configure_logger
      @logger ||= Logger.new($stdout)
      @logger.level = Logger::INFO
    end


  end

  class RssFetchError < StandardError; end
end
