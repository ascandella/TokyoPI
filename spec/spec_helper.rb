require 'rubygems'
require 'bundler/setup'
require 'simplecov'

if ENV['RCOV_COVERAGE'] == 'on'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
end

SimpleCov.start

require_relative '../lib/tokyopi'

# Monkey patch
class TokyoPI::Graphite::GraphiteClient
  attr_accessor :stubs

  def stub_with(&block)
    @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      yield stub
    end
  end

  def connect
    @faraday = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end
  end
end

def test_config(log_level = 'fatal')
  conf = TokyoPI::Configuration.new('test', {
    'debug' => true,
    'log_level' => log_level,
    'graphite' => {
      'host' => 'localhost'
    },
    'mail' => {
      'from' => 'test@test.com',
      'server' => 'nxdomain'
    }
  })
  conf.boot!
  conf
end

