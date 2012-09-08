require 'json'
require 'pp'
describe Dailycred do
  subject do

  end

  before(:each) do
    # site = "https://www.dailycred.com"
    # client_id = "f1fd998c-bc48-4e1b-bc88-98f9373ba60f"
    # secret = "6925d89e-d04d-469e-8fc9-3782af57bc29-c2340f1e-25a0-40af-b638-7429947a6cd7"
    # @user_id = "0c19c355-2a71-4c8e-805e-f7a6087ea84c"

    #dev settings
    site = "http://localhost:9000"
    client_id = "4337ed55-aaca-4e38-8824-6c016c59dd5b"
    secret = "34f2ecc3-f955-4292-9747-39b876d91d8b-a4f7ad8e-f8a4-4573-b23d-686f6e28a820"
    @user_id = "97a85558-c5a6-47de-ab89-4e7de02c99bd"

    dc_options = { :client_options => {
        :site => site,
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/access_token'
      } }

    if File.exists?('/etc/ssl/certs')
      dc_options[:client_options][:ssl] = { :ca_path => '/etc/ssl/certs'}
    end

    if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
      dc_options[:client_options][:ssl] = { :ca_file => '/opt/local/share/curl/curl-ca-bundle.crt' }
    end

    @dc = Dailycred.new client_id, secret, dc_options
  end

  it "tags a user" do
    response = @dc.tag(@user_id, "loser")
    json = JSON.parse response.body
    json["worked"].should == true
    user = json["user"]
    user["tags"].should include('loser')
  end

  it "untags a user" do
    response = @dc.untag(@user_id, "loser")
    json = JSON.parse response.body
    json["worked"].should == true
    user = json["user"]
    user["tags"].should == nil
  end

  it "fires an event" do
    response = @dc.event(@user_id, "became a loser")
    json = JSON.parse response.body
    json["worked"].should == true
  end
end