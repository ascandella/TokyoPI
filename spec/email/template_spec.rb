require_relative '../spec_helper'

describe TokyoPI::Email::Template do

  simple_template = 'spec/template/test_report.erb'
  binding_template = 'spec/template/binding_test.erb'

  it 'should load a template properly' do
    conf = get_config
    template = TokyoPI::Email::Template.new(conf)
    lambda  {
      template.send(:load_template, simple_template)
    }.should_not raise_error
  end

  it 'should render a template properly' do
    conf     = get_config
    template = TokyoPI::Email::Template.new(conf)
    report   = double('report')

    report.should_receive(:template_name).and_return(simple_template)
    report.should_receive(:get_binding).and_return(nil)

    template.render(report).should == "Foo: bar\n"
  end

  it 'should handle a binding properly' do
    conf     = get_config('binding_test', 'test_dashboard')
    template = TokyoPI::Email::Template.new(conf)
    report   = TokyoPI::Report.new(conf, 'binding_test')

    report.template_name.should == binding_template

    result = template.render(report)
    result.should == "<a href=\"/get/test_dashboard\">Foo</a>\n"
  end

  def get_config(name = 'test_report', dash_name = 'test_dashboard')
    conf = test_config
    conf.merge!({
      'reports' => {
        name => {
          'template' => "spec/template/#{name}.erb",
          'dashboards' => [dash_name]
        }
      }
    })
    conf
  end

end
