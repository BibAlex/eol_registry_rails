require 'spec_helper'

describe PeerLog do

  describe "test peer log associations" do
    it "should belongs to push request" do
      t = PeerLog.reflect_on_association(:push_request)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belongs to sync object type" do
      t = PeerLog.reflect_on_association(:sync_object_type)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belongs to sync object action" do
      t = PeerLog.reflect_on_association(:sync_object_action)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belongs to sync object site" do
      t = PeerLog.reflect_on_association(:sync_object_site)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belongs to user site" do
      t = PeerLog.reflect_on_association(:user_site)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should has many log action parameters" do
      t = PeerLog.reflect_on_association(:log_action_parameters)
      expect(t.macro).to eq(:has_many)
    end
  end



  describe("Available peer logs for pull") do
    
    before(:all) do
      @action = SyncObjectAction.create(:object_action => 'create')
      @type = SyncObjectType.create(:object_type => 'User')
      @first_site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_124")
      @second_site = Site.create(:auth_code => "auth_2", :current_uuid => "uuid_123")
      @empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
      @first_site_push = PushRequest.create(:site_id => @first_site.id, :success => true, :uuid => "uuid_124")
      @first_peer_log = PeerLog.create(:push_request_id => @first_site_push.id,
      :sync_object_action_id => @action.id, :sync_object_type_id => @type.id)
      @second_peer_log = PeerLog.create(:push_request_id => @first_site_push.id,
      :sync_object_action_id => @action.id, :sync_object_type_id => @type.id)
    end
    
    it "should return available peer logs for pull" do
      # check returned peer logs
      @peer_logs = PeerLog.new_logs_for_site(@second_site)
      expect(@peer_logs.count).to eq(2)
      expect(@peer_logs.first.id).to eq(@first_peer_log.id)
      expect(@peer_logs[1].id).to eq(@second_peer_log.id)
    end
    
    it "should combine available peer logs for pull" do
      # check combined peer logs
      combined_peer_logs = PeerLog.combine_logs_in_one_json(PeerLog.new_logs_for_site(@second_site))
      expect(combined_peer_logs.count).to eq(2)
    end   
    
    after(:all) do
      @action.destroy
      @type.destroy
      @first_site.destroy
      @second_site.destroy
      @empty_push.destroy
      @first_site_push.destroy
      @first_peer_log.destroy
      @second_peer_log.destroy
    end
  end
end
