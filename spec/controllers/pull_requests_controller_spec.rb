require 'spec_helper'

describe PullRequestsController do

  describe "GET 'pull'" do

    before(:all) do
      @site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_123")
      @empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
      @push_site = Site.create(:auth_code => "auth_2", :current_uuid => "uuid_124")
    end

    it "returns http success" do
      get 'pull', :auth_code => "auth_1", :current_uuid => "uuid_123"
      expect(response).to be_success
    end


    it "should return pull attributes" do
      latest_successful_push_request = PushRequest.create(site_id: @push_site.id, success: true, uuid: "uuid_124")
      get 'pull', auth_code: "auth_1", current_uuid: "uuid_123"
      body = JSON.parse(response.body)
      expect(body['UUID']).to eq("uuid_124")
    end

    it "should have auth code" do
      get 'pull',  :current_uuid => "uuid_123"
      expect(response.code).to eq("400") # response code '400' missing current uuid
    end

    it "should have current uuid" do
      get 'pull', :auth_code => "auth_1"
      expect(response.code).to eq("400") # response code '400' missing auth code
    end

    it "should not accept invalid auth code" do
      get 'pull', :auth_code => "auth_10", :current_uuid => "uuid_123"
      expect(response.code).to eq("401") # response code '401' invalid auth code
    end

    it "should not accept invalid current uuid" do
      get 'pull', :auth_code => "auth_1", :current_uuid => "uuid_126"
      expect(response.code).to eq("401") # response code '401' invalid current uuid
    end

    it "pull request should not success if there is nothing to pull" do
      get 'pull', :auth_code => "auth_1", :current_uuid => "uuid_123"
      expect(response.code).to eq("208") # response code '208' nothing to pull
    end

    it "pull request should not success if there is another pull in progress" do
      latest_successful_push_request = PushRequest.create(:site_id => @push_site.id, :success => true, :uuid => "uuid_124")
      in_progress_pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123", :success => nil)
      get 'pull', :auth_code => "auth_1", :current_uuid => "uuid_123"
      expect(response.code).to eq("405") # response code '405' Another pull is in progress
    end
    
    after(:all) do
      @site.destroy
      @empty_push.destroy
      @push_site.destroy
    end
    
  end

  describe "GET 'report'" do

    before(:all) do
      @site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_123")
    end

    it "returns http success" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_1", :uuid => "uuid_123", :reason => "", :success => "1"
      expect(response).to be_success
    end

    it "response should return true if pull success" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_1", :uuid => "uuid_123", :reason => "", :success => "1"
      expect(response).to be_success      
    end

   

    it "response should return true if pull success" do
      pull_event = PullEvent.create(site_id: @site.id, state_uuid: "uuid_123")
      get 'report', auth_code: "auth_1", uuid: "uuid_123", reason: "", success: "1"
      response.should be_success
      body = JSON.parse(response.body)
      expect(body['success']).to eq(true)
    end

    it "should have auth code" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report',  :uuid => "uuid_123", :reason => "", :success => "1"
      expect(response.code).to eq("400") # response code '400' missing auth code
    end

    it "should have uuid" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_1", :reason => "", :success => "1"
      expect(response.code).to eq("400") # response code '400' missing uuid
    end

    it "should have success parameter" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_1", :uuid => "uuid_123", :reason => ""
      expect(response.code).to eq("400") # response code '400' missing success parameter
    end

    it "should not accept invalid auth code" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_10", :uuid => "uuid_123", :reason => "", :success => "1"
      expect(response.code).to eq("401") # response code '401' invalid auth code
    end

    it "should not success if pull is invalid" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123")
      get 'report', :auth_code => "auth_1", :uuid => "uuid_125", :reason => "", :success => "1"
      expect(response.code).to eq("406") # response code '406' pull is invalid
    end

    it "should not success pull has already been completed" do
      pull_event = PullEvent.create(:site_id => @site.id, :state_uuid => "uuid_123", :success => true)
      get 'report', :auth_code => "auth_1", :uuid => "uuid_123", :reason => "", :success => "1"
      expect(response.code).to eq("406") # response code '406' Pull has already been completed
    end
    
    after(:all) do
      @site.destroy
    end
  end

end
