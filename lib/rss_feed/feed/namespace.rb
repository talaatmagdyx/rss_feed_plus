require 'cgi'
require_relative '../object'

module RssFeed
  module Feed
    # The Namespace module provides utility methods for accessing and manipulating XML namespaces in RSS feeds.
    class Namespace
      # Mapping of namespace prefixes to their corresponding URIs.
      NAMESPACES = {
        'itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'dc' => 'http://purl.org/dc/elements/1.1/',
        'feedburner' => 'http://rssnamespace.org/feedburner/ext/1.0',
        'content' => 'http://purl.org/rss/1.0/modules/content/',
        'trackback' => 'http://example.com/trackback',
        'media' => 'http://search.yahoo.com/mrss/'
      }.freeze

      class << self
        # Accesses the specified XML tag within the document with proper namespace handling.
        #
        # @param tag [String] The XML tag to access.
        # @param doc [Nokogiri::XML::Document] The XML document.
        # @return [Hash] The tag data including text, nested elements flag, nested attributes flag, and the document.
        def access_tag(tag, doc)
          doc = doc.xpath(tag, namespace(tag))
          nested_elements = nested_elements?(doc)
          { text: doc.to_s, nested_elements: nested_elements, nested_attributes: nested_attributes?(doc), docs: doc }
        end

        # Resolves the namespace for the given XML tag.
        #
        # @param tag [String] The XML tag.
        # @return [Hash] The namespace declaration.
        def namespace(tag)
          namespace_key = tag.split(':').first
          { namespace_key.to_s => NAMESPACES[namespace_key] }.compact
        end

        # Removes HTML tags from the given content.
        #
        # @param content [String] The content containing HTML tags.
        # @return [String] The content without HTML tags.
        def remove_html_tags(content)
          if %r{([^-_.!~*'()a-zA-Z\d;/?:@&=+$,\[\]]%)}.match?(content)
            CGI.unescape(content)
          else
            content
          end.gsub(/(<!\[CDATA\[|\]\]>)/, '').strip.gsub(/<[^>]+>/, '')
        end

        # Checks if the XML node has nested elements.
        #
        # @param node [Nokogiri::XML::NodeSet] The XML node.
        # @return [Boolean] Whether the node has nested elements.
        def nested_elements?(node)
          return false if node.blank? || node.to_s == 'NaN'

          return true if node.children.any?(&:element?)

          false
        end

        # Checks if the XML node has nested attributes.
        #
        # @param node [Nokogiri::XML::NodeSet] The XML node.
        # @return [Boolean] Whether the node has nested attributes.
        def nested_attributes?(node)
          return false if node.blank? || node.to_s == 'NaN'

          node.any? { |thumbnail| !thumbnail.attributes.empty? }
        end
      end
    end
  end
end
