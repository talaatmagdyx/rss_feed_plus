require_relative 'base'

module RssFeed
  module Feed
    # The Item class represents an item in an RSS feed.
    class Item < Base
      # List of commonly used tags in an RSS item.
      TAGS = %w[
        id
        title link link+alternate link+self link+edit link+replies
        author contributor
        description summary content content:encoded comments
        pubDate published updated expirationDate modified dc:date
        category guid
        trackback:ping trackback:about
        dc:creator dc:title dc:subject dc:rights dc:publisher
        feedburner:origLink media:content media:thumbnail
        media:title
        media:credit
        media:category
      ].freeze

      # XPath expression for selecting the RSS item.
      def rss
        '//item'
      end

      # XPath expression for selecting the Atom entry.
      def atom
        '//entry'
      end

      alias feed atom
      # Parses the RSS item or Atom entry based on the detected feed type.
      #
      # @return [Nokogiri::XML::NodeSet] The parsed item or entry.
      def parse
        document.xpath(execute_method)
      end
    end
  end
end
