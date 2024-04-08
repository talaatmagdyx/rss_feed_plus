require_relative 'base'
require_relative '../object'

module RssFeed
  module Feed
    # The Channel class represents a channel in an RSS feed.
    class Channel < Base
      # List of commonly used tags in an RSS channel.
      TAGS = %w[
        id
        title subtitle link
        description
        author webMaster managingEditor contributor
        pubDate lastBuildDate updated dc:date
        generator language docs cloud
        ttl skipHours skipDays
        image logo icon rating
        rights copyright
        textInput feedburner:browserFriendly
        itunes:author itunes:category category itunes:explicit itunes:image itunes:keywords itunes:owner itunes:subtitle
        itunes:summary
      ].freeze

      # XPath expression for selecting the RSS channel.
      def rss
        return nil if document.blank?

        '//channel'
      end

      # XPath expression for selecting the Atom feed.
      def atom
        return nil if document.blank?

        '//xmlns:feed'
      end

      alias feed atom

      # Parses the RSS channel or Atom feed based on the detected feed type.
      #
      # @return [Nokogiri::XML::NodeSet, nil] The parsed channel or feed, or nil if not found.
      def parse
        document.xpath(execute_method)
      end
    end
  end
end
