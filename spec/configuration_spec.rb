require_relative 'spec_helper'

describe TokyoPI::Configuration do

  it 'should default to loading from a file' do
    conf = TokyoPI::Configuration.new('test')
    conf['reports'].should_not be_nil
  end

  it 'should raise when the environment is invalid' do
    lambda {
      TokyoPI::Configuration.new('mars')
    }.should raise_error(TokyoPI::ConfigurationException)
  end

  it 'should complain when the filename is invalid' do
    lambda {
      TokyoPI::Configuration.new('test', 'mars.yml')
    }.should raise_error(TokyoPI::ConfigurationException)
  end
  
  it 'should generate a unique run id' do
    TokyoPI::Configuration.new('test').run_id.should_not be_nil
  end

  it 'should raise when the image store is nonsensical' do
    conf = test_config
    conf.merge!({ 'email' => { 'image_display_method' => 'venn_diagram' } })
    lambda {
      conf.image_store
    }.should raise_error(TokyoPI::ConfigurationException)
  end

end
