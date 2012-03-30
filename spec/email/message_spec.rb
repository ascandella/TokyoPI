require_relative '../spec_helper'

describe TokyoPI::Email::Message do
  it 'should initialize properly' do
    lambda { TokyoPI::Email::Message.new(test_config, nil) }.should_not raise_error
  end
end
