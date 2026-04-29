require 'minitest/autorun'
require 'mocha/minitest'
require 'storazzo'
require 'storazzo/gcs/client'

class GcsClientTest < Minitest::Test
  def setup
    ENV['GOOGLE_CLOUD_PROJECT'] = 'test-project'
    ENV['GCS_BUCKET'] = nil
    @mock_storage = mock()
    Google::Cloud::Storage.stubs(:new).returns(@mock_storage)
  end

  def test_default_bucket_name
    client = Storazzo::GCS::Client.new('test-project')
    assert_equal 'test-project-storazzo', client.bucket_name
  end

  def test_custom_bucket_name_from_env
    ENV['GCS_BUCKET'] = 'my-custom-bucket'
    client = Storazzo::GCS::Client.new('test-project')
    assert_equal 'my-custom-bucket', client.bucket_name
  end

  def test_ensure_bucket_exists_when_it_does
    client = Storazzo::GCS::Client.new('test-project')
    mock_bucket = mock()
    @mock_storage.expects(:bucket).with('test-project-storazzo').returns(mock_bucket)
    
    assert client.ensure_bucket_exists
  end

  def test_ensure_bucket_exists_when_it_does_not_creates_it
    client = Storazzo::GCS::Client.new('test-project')
    
    # First check returns nil, then create_bucket is called
    @mock_storage.expects(:bucket).with('test-project-storazzo').returns(nil)
    @mock_storage.expects(:create_bucket).with('test-project-storazzo').returns(true)
    
    assert client.ensure_bucket_exists
  end
end
