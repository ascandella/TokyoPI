require_relative '../spec_helper'

describe TokyoPI::Storage::ImageStore do

  it 'should need to be subclassed' do
    lambda {
      TokyoPI::Storage::ImageStore.new(test_config).add('foo')
    }.should raise_error
  end

end

describe TokyoPI::Storage::NoopStore do

  it 'should return an absolute url' do
    conf = test_config
    conf.merge!('graphite' => { 'host' => 'foo.bar' })
    store = TokyoPI::Storage::NoopStore.new(conf)
    store.add('baz.png')
    store.fetch('baz.png').should == 'http://foo.bar/baz.png'
  end

  it 'should not raise when overwriting an image' do
    store = TokyoPI::Storage::NoopStore.new(test_config)
    store.add('foo.gif')
    lambda { store.add('foo.gif') } .should_not raise_error
  end

  it 'should raise when an unregistered graph is fetched' do
    store = TokyoPI::Storage::NoopStore.new(test_config)
    lambda { store.fetch('baz.png') }.should raise_error
  end

end
