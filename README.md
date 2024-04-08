# rss_feed_plus

## Introduction

**rss_feed_plus** is your go-to Ruby gem for effortlessly fetching and parsing RSS feeds. Whether you're building a news aggregator, content management system, or simply want to integrate RSS feeds into your application, **rss_feed_plus** simplifies the process, allowing you to easily retrieve and process RSS feed data from various sources.

## Features

- **Effortless Parsing**: Fetch and parse RSS feeds with ease.
- **Customization: Tailor** parsing to fit your needs with customizable XML and URI parsers and timeout duration.
- **Seamless Integration**: Integrate with Ruby applications smoothly.

## Installation

Getting started with **rss_feed_plus** is quick and easy. Simply add the gem to your application's Gemfile:

```ruby
gem 'rss_feed_plus'
```

Then, install the gem by running:

```bash
bundle install
```

Alternatively, you can install the gem directly using RubyGems:

```bash
gem install rss_feed_plus
```

## Usage

Here's a basic example of how to use **rss_feed_plus** to fetch and parse RSS feeds:

```ruby
require 'rss_feed'
require 'nokogiri'

# Define your custom options
feed_urls = 'https://www.ruby-lang.org/en/feeds/news.rss'
xml_parser = Nokogiri
uri_parser = URI
timeout = 10

# Initialize the Parser class with custom options
parser = RssFeed::Parser.new(feed_urls, xml_parser: xml_parser, uri_parser: uri_parser, timeout: timeout)
# or 
parser = RssFeed::Parser.new(feed_urls)
# Parse the RSS feeds
parsed_data = parser.parse_as_object 

# OR  Parse the RSS feed as a JSON
parsed_data = parser.parse

# Process the parsed data
puts parsed_data.inspect
```

## Customization

**rss_feed_plus** allows you to tailor the parsing process to fit your needs. Customize the XML parser, URI parser, and timeout duration according to your requirements.

## Contributing

Contributions to **rss_feed_plus** are welcome! If you encounter any issues, have feature requests, or would like to contribute enhancements, please feel free to open an issue or submit a pull request on [GitHub](https://github.com/talaatmagdyx/rss_feed_plus).

Before contributing, please review the [Contributing Guidelines](https://github.com/talaatmagdyx/rss_feed_plus/blob/master/.github/CONTRIBUTING.md) and adhere to the [Code of Conduct](https://github.com/talaatmagdyx/rss_feed_plus/blob/master/.github/CODE_OF_CONDUCT.md).

## Reporting Bugs / Feature Requests

If you encounter any bugs or have suggestions for new features, please [open an issue on GitHub](https://github.com/talaatmagdyx/rss_feed_plus/issues). Your feedback is valuable and helps improve the quality of the gem.

## License

**rss_feed_plus** is released under the [MIT License](https://opensource.org/licenses/MIT). You are free to use, modify, and distribute the gem according to the terms of the license.

## Code of Conduct

Please review and adhere to the [Code of Conduct](https://github.com/talaatmagdyx/rss_feed_plus/blob/master/.github/CODE_OF_CONDUCT.md) when interacting with the **rss_feed_plus** project. We strive to maintain a welcoming and inclusive community for all contributors and users.

---

Experience the simplicity of RSS feed integration with **rss_feed_plus**. Happy coding!