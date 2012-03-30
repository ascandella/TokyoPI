require_relative '../spec_helper'

describe TokyoPI::Graphite::GraphiteClient do

  it 'should initialize' do
    lambda {
      TokyoPI::Graphite::GraphiteClient.new(test_config)
    }.should_not raise_error
  end

  it 'should parse json properly' do
    json_client = TokyoPI::Graphite::GraphiteJsonClient.new(test_config)
    json_client.stub_with do |stub|
      stub.get('/foo/bar') { [200, {}, {'key' => 'value'}] }
    end

    json_client.connect
    json_client.get('/foo/bar').body.should_not be_nil
    json_client.get('/foo/bar').body['key'].should == 'value'
  end

end
