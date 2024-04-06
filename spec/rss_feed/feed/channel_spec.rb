require_relative '../../../lib/rss_feed/feed/channel' # Adjust the path as per your file structure
require 'nokogiri'

RSpec.describe RssFeed::Feed::Channel do
  let(:channel_xml) { File.read('rss_example/news.rss') } # Replace with the path to your channel XML file

  describe '#rss' do
    it 'returns the XPath expression for selecting the nil channel' do
      channel = described_class.new(nil) # Pass nil for document as it's not required for this test
      expect(channel.rss).to be_nil
    end

    it 'returns the XPath expression for selecting the RSS channel' do
      channel = described_class.new(Nokogiri::XML(channel_xml)) # Pass nil for document as it's not required for this test
      expect(channel.rss).to eq('//channel')
    end
  end

  describe '#atom' do
    it 'returns the XPath expression for selecting the nil feed' do
      channel = described_class.new(nil) # Pass nil for document as it's not required for this test
      expect(channel.atom).to be_nil
    end

    it 'returns the XPath expression for selecting the Atom feed' do
      channel = described_class.new(Nokogiri::XML(channel_xml)) # Pass nil for document as it's not required for this test
      expect(channel.atom).to eq('//feed')
    end
  end

  describe '#parse' do
    it 'returns the parsed channel when parsing RSS XML' do
      channel = described_class.new(Nokogiri::XML(channel_xml))
      expect(channel.parse).to be_instance_of(Nokogiri::XML::NodeSet)
    end
  end
end
