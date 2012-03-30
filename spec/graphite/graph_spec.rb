require_relative '../spec_helper'

describe TokyoPI::Graphite::Graph do

  it 'should complain when graph is not a valid config' do
    lambda {
      TokyoPI::Graphite::Graph.new(test_config, ['foo'])
    }.should raise_error
  end

  it 'should complain when the uri returned is invalid' do
    lambda {
      TokyoPI::Graphite::Graph.new(test_config, [ nil, nil, 'gopher_party\backslash' ])
    }.should raise_error
  end

  it 'should use graphite params when no user-specified are provided' do
    url = '/render?foo=bar&target=mars' 
    TokyoPI::Graphite::Graph.new(test_config, [
      nil, nil, url
    ]).url.should == url
  end

  it 'should allow overriding values' do
    conf = test_config
    conf.merge!({
      'graphs' => {
        'foo' => 500,
        'target' => 'pluto'
      }
    })
    # Note: This may not be a good test, as it depends on hash-ordering
    TokyoPI::Graphite::Graph.new(conf, [nil, nil,
      '/render?foo=300&target=baz&aoeu=ueoa'
    ]).url.should == '/render?foo=500&target=pluto&aoeu=ueoa'
  end

  it 'should prefer override values from a report' do
    report = double('report')
    report.should_receive(:report_config).at_least(:once).and_return({
      'graphs' => {
        'foo' => 42
      }
    })
    
    conf = test_config
    conf.merge!({
      'graphs' => {
        'foo' => 500,
      }
    })
    # Note: This may not be a good test, as it depends on hash-ordering
    TokyoPI::Graphite::Graph.new(conf, [nil, nil,
      '/render?foo=300&target=baz&aoeu=ueoa'
    ], report).url.should == '/render?foo=42&target=baz&aoeu=ueoa'
    
  end
end
