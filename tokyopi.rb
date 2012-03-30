#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'trollop'

require './lib/tokyopi'

opts = Trollop::options do
  banner <<-EOS
usage: #{__FILE__} [options]

Options:
EOS
  opt :config,      'Load configuration from this file',
      :default =>    File.join(File.dirname(__FILE__), 'config.yml')

  opt :environment, 'Use specified environment for configuration',
      :default =>   'production'

  opt :report,      'Run this report',
      :default =>   'default'
end

Trollop::die :config, 'must exist' unless File.exist?(opts[:config])


cli = TokyoPI::CommandLine.new
begin
  cli.load_config!(opts[:environment], opts[:config])
  cli.run_report(opts[:report])
rescue TokyoPI::TokyoPIException => ex
  TokyoPI.log.error "Internal exception, bailing: #{ex}"
  raise ex
rescue Exception => ex
  TokyoPI.log.fatal "Unhandled exception caught: #{ex}"
  raise ex
end
