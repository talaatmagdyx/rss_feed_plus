require_relative '../../../lib/rss_feed/feed/namespace'
require_relative '../../../lib/rss_feed/feed/channel'
require 'nokogiri'

RSpec.describe RssFeed::Feed::Namespace do
  describe '.access_tag' do
    let(:xml_doc) { File.read('rss_example/news.rss') }
    let(:tag) { 'title' }
    let(:document) { Nokogiri::XML(xml_doc) }
    let(:channel) { RssFeed::Feed::Channel.new(document) }
    let(:tag_data) { described_class.access_tag(tag, channel.parse) }

    it 'returns the tag data including text' do
      expect(tag_data[:text]).to eq('<title>Ruby News</title>')
    end

    it 'returns the tag data nested elements flag' do
      expect(tag_data[:nested_elements]).to be_falsey
    end

    it 'returns the tag data nested attributes flag' do
      expect(tag_data[:nested_attributes]).to be_falsey
    end
  end

  describe '.namespace' do
    it 'resolves the namespace for the given XML tag' do
      tag = 'itunes:author'
      namespace_declaration = described_class.namespace(tag)

      expect(namespace_declaration).to eq('itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd')
    end
  end

  describe '.remove_html_tags' do
    it 'removes HTML tags from the given content' do
      content_with_html = '<p>This is <strong>bold</strong> text</p>'
      clean_content = described_class.remove_html_tags(content_with_html)

      expect(clean_content).to eq('This is bold text')
    end
  end

  describe '.nested_elements?' do
    it 'checks if the XML node has nested elements' do
      xml_doc = Nokogiri::XML('<parent><child>data</child></parent>')
      node = xml_doc.xpath('//parent')

      expect(described_class).to be_nested_elements(node)
    end
  end

  describe '.nested_attributes?' do
    it 'checks if the XML node has nested attributes' do
      xml_doc = Nokogiri::XML('<parent attribute="value">data</parent>')
      node = xml_doc.xpath('//parent')
      p node
      expect(described_class).to be_nested_attributes(node)
    end
  end
end
