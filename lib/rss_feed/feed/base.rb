module RssFeed
  module Feed
    class Base
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def parser
        raise NotImplementedError
      end

      private

      def detect_feed_type
        document.root.name
      end

      def execute_method
        method_name = detect_feed_type
        raise NotImplementedError unless respond_to?(method_name)

        send(method_name)
      end
    end
  end
end
