source :rubygems

gem 'rake'
gem 'pony'
gem 'aws-s3'
gem 'faraday'
gem 'faraday_middleware'
gem 'json'
gem 'trollop'

group :test do
  gem 'rspec', :require => false
  gem 'simplecov', :require => false
  # Because Jenkins doesn't understand simplecov's format
  # Only used if you set RCOV_COVERAGE=on in your environment
  # while running the tests
  gem 'simplecov-rcov', :require => false
end
