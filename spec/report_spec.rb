require_relative 'spec_helper'

describe TokyoPI::Report do
  
  it 'should setup properly' do
    lambda {
      report = TokyoPI::Report.new(get_config, 'test-report')
    }.should_not raise_error
  end

  it 'should use a report-specific template if specified' do
    get_report do |conf|
      conf.config['reports']['test-report']['template'] = 'template_specific.erb'
    end.template_name.should == 'template_specific.erb'
  end

  it 'should use the config-wide template if no report-specific one is provided' do
    get_report('default_template' => 'default.erb')
      .template_name.should == 'default.erb'
  end

  it 'should complain when no dashboards are provided' do
    lambda {
      get_report do |conf|
        conf.config['reports']['test-report']['dashboards'] = nil
      end
    }.should raise_error
  end

  it 'should complain when the specified report is invalid' do
    lambda {
      TokyoPI::Report.new(get_config, 'i-dont-exist')
    }.should raise_error(TokyoPI::ConfigurationException)
  end

  it 'should have a subject' do
    conf = get_config
    conf.config['reports']['test-report']['name'] = 'my report'
    TokyoPI::Report.new(conf, 'test-report')
      .subject.should == 'my report'
  end

  it 'should have a heading' do
    conf = get_config
    conf.config['reports']['test-report']['heading'] = 'my heading'
    TokyoPI::Report.new(conf, 'test-report')
      .heading.should == 'my heading'
  end

  it 'should fall back to the subject for a heading' do
    conf = get_config
    conf.config['reports']['test-report']['name'] = 'my report'
    TokyoPI::Report.new(conf, 'test-report')
      .heading.should == 'my report'
  end

  it 'should use the override recipient' do
    conf = get_config
    conf.config['reports']['test-report']['recipient'] = 'me'
    TokyoPI::Report.new(conf, 'test-report')
      .recipient.should == 'me'
  end

  it 'should encode properly' do
    report = get_report
    report.dashboards.length.should == 1
    report.dashboards[0].should_receive(:fetch_graphs!)
    report.encode
  end

  # Helpers
  def get_report(overrides = nil)
    conf = get_config
    conf.merge!(overrides) if overrides
    yield conf if block_given?

    report = TokyoPI::Report.new(conf, 'test-report')
    report
  end

  def get_config
    conf = test_config
    conf.merge!({
      'reports' => {
        'test-report' => {
          'dashboards' => ['foo']
        }
      }
    })
    conf
  end
end
