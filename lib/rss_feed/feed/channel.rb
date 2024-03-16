require_relative 'base'

module RssFeed
  module Feed
    class Channel < Base
      TAGS = %i[
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
        itunes:author itunes:category
      ].freeze

      def rss
        '//channel'
      end

      def atom
        '//feed'
      end

      def parse
        document.at_xpath(execute_method)
      end
    end
  end
end
