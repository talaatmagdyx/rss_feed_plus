# frozen_string_literal: true

RSpec.describe RssFeed do
  it 'has a version number' do
    expect(RssFeed::VERSION).not_to be_nil
  end
end
