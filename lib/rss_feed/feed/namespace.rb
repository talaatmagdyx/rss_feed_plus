require "cgi"

module RssFeed
  module Feed
    class Namespace

      NAMESPACES = {
        'itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'dc' => 'http://purl.org/dc/elements/1.1/',
        'feedburner' => 'http://rssnamespace.org/feedburner/ext/1.0',
        'content' => 'http://purl.org/rss/1.0/modules/content/',
        'trackback' => 'http://example.com/trackback',
        'media' => 'http://search.yahoo.com/mrss/'
      }.freeze

      class << self
        def access_tag(tag, doc)
          tag = tag.to_s
          if tag.include?(':')
            element = doc.at_xpath("//#{tag.split('#').first}", namespace(tag))

            tag.include?('#') ? element&.attribute(tag.split('#').last)&.value : element
          else
            doc.xpath(tag).to_s
          end
        end

        def namespace(tag)
          namespace_key = tag.split(':').first
          { namespace_key.to_s => NAMESPACES[namespace_key] }.compact
        end


        def remove_html_tags(content)
          if /([^-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]%)/.match?(content)
            CGI.unescape(content)
          else
            content
          end.gsub(/(<!\[CDATA\[|\]\]>)/, "").strip.gsub(/<[^>]+>/, '')
        end

        def has_nested_elements?(node)
          return false unless node

          return true if node.children.any? { |child| child.element? }
          false
        end
      end

    end
  end
end
