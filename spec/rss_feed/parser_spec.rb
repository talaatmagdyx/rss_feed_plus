RSpec.describe RssFeed::Parser do
  describe '#initialize' do
    it 'initializes with feed URLs' do
      feed_urls = 'https://www.ruby-lang.org/en/feeds/news.rss'
      parser = described_class.new(feed_urls)

      expect(parser.feed_urls).to eq(feed_urls)
    end
  end
end
