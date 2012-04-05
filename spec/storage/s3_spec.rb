require_relative '../spec_helper'

describe TokyoPI::Storage::S3 do
  it 'should establish a connection' do
    conf = test_config
    s3_creds = {
      'access_key' => 'access',
      'secret_access_key' => 'hunter2'
    } 
    conf.merge!({ 's3' => s3_creds })
    AWS::S3::Base.should_receive(:establish_connection!)
      .with(:access_key_id => 'access',
            :secret_access_key => 'hunter2')
    
    TokyoPI::Storage::S3.new(conf)
  end
end
