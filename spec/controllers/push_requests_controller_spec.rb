require 'spec_helper'

describe PushRequestsController do

  describe "GET 'create'" do

    before(:all) do
      truncate_all_tables
      site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_123")
      empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
    end

    it "returns http success" do
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.should be_success
    end

    it "should return push request uuid  push when push success" do
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      body = JSON.parse(response.body)
      body["uuid"].should_not be_nil
    end

    it "should have auth code" do
      post 'create', :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "400"
    end

    it "should have current uuid" do
      post 'create', :auth_code => "auth_1",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "400"
    end

    it "should have file url" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_md5_hash => "file.md5"
      response.code.should == "400"
    end

    it "should have file hash url" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "file.json"
      response.code.should == "400"
    end

    it "file url should not be blank" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "",
                     :file_md5_hash => "file.md5"
      response.code.should == "400"
    end

    it "file hash url should not be blank" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => ""
      response.code.should == "400"
    end

    it "should not accept invalid auth code" do
      post 'create', :auth_code => "invalid_auth_code", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "401"
    end

    it "should not accept invalid current uuid" do
      post 'create', :auth_code => "auth_1", :current_uuid => "invalid_uuid",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "401"
    end

    it "push request should not success if registry is busy" do
      pending_push = PushRequest.create(:success => nil, :uuid => "uuid_123")
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "405"
    end

    it "should pull first" do
      second_site = Site.create(:auth_code => "auth_2", :current_uuid => "uuid_124")
      successful_push_request = PushRequest.create(:site_id => second_site.id, :success => true, :uuid => "uuid_124")
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      response.code.should == "409"
    end
  end

  describe "GET 'show'" do

    before(:all) do
      truncate_all_tables
      site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_124")
      empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
      successful_push_request = PushRequest.create(:site_id => site.id, :success => true, :uuid => "uuid_124")
    end

    it "returns http success" do
      get 'show', :uuid => "uuid_124"
      response.should be_success
    end

    it "response should return true when push success" do
      get 'show', :uuid => "uuid_124"
      response.should be_success
      body = JSON.parse(response.body)
      body["success"].should == true
      body["failed_reason"].should be_nil
      body["failed_at"].should be_nil
    end

    it "should have uuid" do
      get 'show'
      response.code.should == "400"
    end

    it "should not accept invalid uuid" do
      get 'show', :uuid => "uuid_126"
      response.code.should == "401"
    end
  end

end
