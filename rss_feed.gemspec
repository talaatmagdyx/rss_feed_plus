require_relative 'lib/rss_feed/version'

Gem::Specification.new do |spec|
  spec.name = 'rss_feed_plus'
  spec.version = RssFeed::VERSION
  spec.authors = ['talaatmagdyx']
  spec.email = ['talaatmagdy75@gmail.com']

  spec.summary = 'A simple RSS parser gem for Ruby'
  spec.description = <<-DESC
    #{spec.name} is a Ruby gem designed to simplify the process of parsing RSS feed in Ruby applications.#{' '}
    It provides a straightforward interface for fetching RSS feed from URLs and extracting relevant information#{' '}
    such as titles, links, descriptions, publication dates, and authors.#{' '}
    With #{spec.name}, you can quickly integrate RSS feed parsing functionality into your Ruby projects,#{' '}
    making it easy to work with syndicated content from various sources.
  DESC
  spec.homepage = 'https://github.com/talaatmagdyx/rss_feed_plus'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/talaatmagdyx/rss_feed_plus'
  spec.metadata['changelog_uri'] = 'https://github.com/talaatmagdyx/rss_feed_plus/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/talaatmagdyx/rss_feed_plus/issues'
  spec.metadata['wiki_uri'] = 'https://github.com/talaatmagdyx/rss_feed_plus/wiki'
  spec.post_install_message = "Thanks for installing! #{spec.name} is a simple RSS parser gem for Ruby."
  spec.platform = Gem::Platform::RUBY

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
