require_relative 'base'

module RssFeed
  module Feed
    class Item < Base
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


      def rss
        '//item'
      end

      def atom
        '//entry'
      end

      def parse
        document.xpath(execute_method)
      end
    end
  end
end
