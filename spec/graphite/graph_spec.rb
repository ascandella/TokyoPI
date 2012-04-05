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
        'target' => 'pluto'
      }
    })
    TokyoPI::Graphite::Graph.new(conf, [nil, nil,
      '/render?target=mars'
    ]).url.should == '/render?target=pluto'
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
    TokyoPI::Graphite::Graph.new(conf, [nil, nil,
      '/render?foo=300'
    ], report).url.should == '/render?foo=42'
  end

  it 'should be available if getting succeeds' do
    url = '/render' 
    conf = test_config
    store = double('store')
    store.should_receive(:add)
    conf.should_receive(:image_store).and_return(store)
    graph = TokyoPI::Graphite::Graph.new(conf, [ nil, nil, url ])
    graph.prepare!
    graph.available?.should be_true
  end

  it 'should not be available if getting fails' do
    url = '/render' 
    conf = test_config
    store = double('store')
    store.should_receive(:add).and_raise(TokyoPI::GraphiteException.new)
    conf.should_receive(:image_store).and_return(store)
    graph = TokyoPI::Graphite::Graph.new(conf, [ nil, nil, url ])
    graph.prepare!
    graph.available?.should be_false
  end

end
