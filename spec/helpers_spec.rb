require_relative 'spec_helper'

describe TokyoPI::Helpers do
  class DummyConfigured < TokyoPI::Configured
    include TokyoPI::Helpers
  end

  before(:each) do 
    @halp = DummyConfigured.new(test_config)
  end

  it 'should be able to fetch a theme' do
    @halp.config.config['email'] = {'theme' => 'foo'}
    @halp.theme.should == 'foo'
  end

  it 'should dive into the theme when asked' do
    @halp.config.config['email'] = {'theme' => {'foo' => 'bar'}}
    @halp.theme('foo').should == 'bar'
  end

  it 'should be able to perform date substitution' do
    @halp.substitute('foo $date').should == "foo #{Date.today.to_s}"
  end

  it 'should get an img url from the image_store' do
    store = double('image_store')
    store.should_receive(:fetch).and_return('here_you_go.ico')
    graph = double('graph')
    graph.should_receive(:url)

    @halp.config.should_receive(:image_store).and_return(store)
    @halp.img_url(graph).should == 'here_you_go.ico'
  end
end
