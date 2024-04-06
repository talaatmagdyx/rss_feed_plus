require_relative '../../../lib/rss_feed/feed/item' # Assuming 'item.rb' contains the Item class definition
require 'nokogiri'

RSpec.describe RssFeed::Feed::Item do
  let(:rss_xml) { File.read('rss_example/news.rss') }
  let(:atom_xml) { File.read('rss_example/prog.xml') }

  describe '#rss' do
    it 'returns the XPath expression for selecting the RSS item' do
      item = described_class.new(nil) # Pass nil for document as it's not required for this test
      expect(item.rss).to eq('//item')
    end
  end

  describe '#atom' do
    it 'returns the XPath expression for selecting the Atom entry' do
      item = described_class.new(nil) # Pass nil for document as it's not required for this test
      expect(item.atom).to eq('//entry')
    end
  end

  describe '#parse' do
    it 'returns the parsed item when parsing RSS XML' do
      item = described_class.new(Nokogiri::XML(rss_xml))
      expect(item.parse).to be_instance_of(Nokogiri::XML::NodeSet)
    end

    it 'returns the parsed entry when parsing Atom XML' do
      item = described_class.new(Nokogiri::XML(atom_xml))
      expect(item.parse).to be_instance_of(Nokogiri::XML::NodeSet)
    end
    # Add more tests as needed
  end
end
