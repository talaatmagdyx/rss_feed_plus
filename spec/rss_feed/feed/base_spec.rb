require_relative '../../../lib/rss_feed/feed/base'

RSpec.describe RssFeed::Feed::Base do
  describe '#detect_feed_type' do
    let(:rss_xml) { File.read('rss_example/news.rss') }
    let(:atom_xml) { File.read('rss_example/prog.xml') }

    it 'detects the type of the RSS feed' do
      base = described_class.new(Nokogiri::XML(rss_xml))
      expect(base.send(:detect_feed_type)).to eq('rss')
    end

    it 'detects the type of the Atom feed' do
      base = described_class.new(Nokogiri::XML(atom_xml))
      expect(base.send(:detect_feed_type)).to eq('feed')
    end
  end
end
