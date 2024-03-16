module RssFeed
  module Feed
    class Namespace

      NAMESPACES = {
        'itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'dc' => 'http://purl.org/dc/elements/1.1/',
        'feedburner' => 'http://rssnamespace.org/feedburner/ext/1.0',
        'content' => 'http://purl.org/rss/1.0/modules/content/'
      }.freeze

      class << self
        def access_tag(tag, doc)
          tag = tag.to_s
          tag.include?(':') ? doc.at_xpath("//#{tag}", namespace(tag)) : doc.xpath(tag).text
        end

        def namespace(tag)
          namespace_key = tag.split(':').first
          { namespace_key.to_s => NAMESPACES[namespace_key] }
        end
      end

    end
  end
end
