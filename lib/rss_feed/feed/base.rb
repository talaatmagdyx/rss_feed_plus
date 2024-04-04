module RssFeed
  module Feed
    # The Base class serves as the base class for all feed parsers.
    class Base
      attr_reader :document

      # Initializes a new Base instance.
      #
      # @param document [Nokogiri::XML::Document] The parsed XML document.
      def initialize(document)
        @document = document
      end

      # This method should be implemented by subclasses to define the specific parsing logic.
      #
      # @abstract
      def parser
        raise NotImplementedError
      end

      private

      # Detects the type of the feed based on the root element of the XML document.
      #
      # @return [String] The name of the root element.
      def detect_feed_type
        document.root.name
      end

      # Executes the appropriate parsing method based on the detected feed type.
      #
      # @raise [NotImplementedError] If the parsing method for the detected feed type is not implemented.
      def execute_method
        method_name = detect_feed_type
        raise NotImplementedError unless respond_to?(method_name)

        send(method_name)
      end
    end
  end
end
