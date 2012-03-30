require_relative '../spec_helper'

describe TokyoPI::Graphite::Dashboard do

  it 'should initialize' do
    lambda {
      TokyoPI::Graphite::Dashboard.new(test_config, 'foo')
    }.should_not raise_error
  end

  it 'should link to the proper href' do
    TokyoPI::Graphite::Dashboard.new(test_config, 'foo').href
      .should == 'http://localhost/dashboard/foo'
  end


  it 'should fetch the config when asked for graphs' do
    dash = TokyoPI::Graphite::Dashboard.new(test_config, 'foo')
    dash.should_receive(:fetch_config)
    dash.fetch_graphs!
  end

  it 'should raise when the dashboard json is invalid' do
    lambda {
      stubbed_dash(
        'no_state' => 'bad_config' 
      ).fetch_config
    }.should raise_error
  end

  it 'should parse graphs properly' do
    response = {
      'state' => {
        'graphs' => [
          ['foo', 'foo', '/render?foo=bar']
        ]
      }
    }
    dash = stubbed_dash_ok(response)
    lambda { dash.fetch_config }.should_not raise_error
    dash.graphs.should_not be_nil
    dash.graphs.length.should == 1
  end

  it 'should complain when the get fails with a SocketError' do
    lambda {
      stubbed_dash do
        raise SocketError.new
      end.fetch_config
    }.should raise_error(TokyoPI::GraphiteException)
  end

  it 'should complain when the get fails with a Faraday ClientError' do
    lambda {
      stubbed_dash do
        raise Faraday::Error::ClientError.new(nil)
      end.fetch_config
    }.should raise_error(TokyoPI::GraphiteException)
  end

  def stubbed_dash_ok(response, name='foo')
    stubbed_dash(name) do
      [200, {}, response]
    end
  end

  def stubbed_dash(name = 'foo')
    dash = TokyoPI::Graphite::Dashboard.new(test_config, name)
    dash.stub_with do |stub|
      stub.get("/dashboard/load/#{name}") { yield }
    end
    dash
  end

end
