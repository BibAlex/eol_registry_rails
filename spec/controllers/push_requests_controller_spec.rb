require 'spec_helper'

describe PushRequestsController do

  describe "GET 'create'" do

    before(:all) do
      truncate_all_tables
      @site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_123")
      @empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
    end

    it "returns http success" do
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response).to be_success
    end

    it "should return push request uuid  push when push success" do
      post 'create', auth_code: "auth_1", current_uuid: "uuid_123",
                     file_url: "file.json",
                     file_md5_hash: "file.md5"
      body = JSON.parse(response.body)
      expect(body['uuid']).not_to be_nil
    end

    it "should have auth code" do
      post 'create', :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("400") # response code '400' missing auth code
    end

    it "should have current uuid" do
      post 'create', :auth_code => "auth_1",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("400") # response code '400' missing current uuid
    end

    it "should have file url" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("400") # response code '400' missing file url
    end

    it "should have file hash url" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "file.json"
      expect(response.code).to eq("400") # response code '400' missing file hash url 
    end

    it "file url should not be blank" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("400") # response code '400' missing file url(blank file url)
    end

    it "file hash url should not be blank" do
      post 'create', :auth_code => "auth_1",
                     :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => ""
      expect(response.code).to eq("400") # response code '400' missing file hash url (blank file hash url)
    end

    it "should not accept invalid auth code" do
      post 'create', :auth_code => "invalid_auth_code", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("401") # response code '401' invalid auth code
    end

    it "should not accept invalid current uuid" do
      post 'create', :auth_code => "auth_1", :current_uuid => "invalid_uuid",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("401") # response code '401' invalid current uuid
    end

    it "push request should not success if registry is busy" do
      pending_push = PushRequest.create(:success => nil, :uuid => "uuid_123")
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("405") # response code '405' registry is busy
    end

    it "should pull first" do
      second_site = Site.create(:auth_code => "auth_2", :current_uuid => "uuid_124")
      successful_push_request = PushRequest.create(:site_id => second_site.id, :success => true, :uuid => "uuid_124")
      post 'create', :auth_code => "auth_1", :current_uuid => "uuid_123",
                     :file_url => "file.json",
                     :file_md5_hash => "file.md5"
      expect(response.code).to eq("409") # response code '409' pull first
    end
  end

  describe "GET 'show'" do

    before(:all) do
      truncate_all_tables
      @site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_124")
      @empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
      @successful_push_request = PushRequest.create(:site_id => @site.id, :success => true, :uuid => "uuid_124")
    end

    it "returns http success" do
      get 'show', :uuid => "uuid_124"
      expect(response).to be_success
    end

    it "response should return true when push success" do
      get 'show', uuid: "uuid_124"
      response.should be_success
      body = JSON.parse(response.body)
      expect(body['success']).to be_true
      expect(body['failed_reason']).to be_nil
      expect(body['failed_at']).to be_nil  
    end

    it "should have uuid" do
      get 'show'
      expect(response.code).to eq("400") # response code '400' missing uuid
    end

    it "should not accept invalid uuid" do
      get 'show', :uuid => "uuid_126"
      expect(response.code).to eq("401") # response code '401' invalid uuid
    end
  end
end
