require 'spec_helper'

describe PeerLog do

  before(:all) do
    truncate_all_tables
  end

  describe "test peer log associations" do
    it "should belongs to push request" do
      t = PeerLog.reflect_on_association(:push_request)
      t.macro.should == :belongs_to
    end

    it "should belongs to sync object type" do
      t = PeerLog.reflect_on_association(:sync_object_type)
      t.macro.should == :belongs_to
    end

    it "should belongs to sync object action" do
      t = PeerLog.reflect_on_association(:sync_object_action)
      t.macro.should == :belongs_to
    end

    it "should belongs to sync object site" do
      t = PeerLog.reflect_on_association(:sync_object_site)
      t.macro.should == :belongs_to
    end

    it "should belongs to user site" do
      t = PeerLog.reflect_on_association(:user_site)
      t.macro.should == :belongs_to
    end

    it "should has many log action parameters" do
      t = PeerLog.reflect_on_association(:log_action_parameters)
      t.macro.should == :has_many
    end
  end

  it "should return available peer logs for pull" do
    action = SyncObjectAction.create(:object_action => 'create')
    type = SyncObjectType.create(:object_type => 'User')
    first_site = Site.create(:auth_code => "auth_1", :current_uuid => "uuid_124")
    second_site = Site.create(:auth_code => "auth_2", :current_uuid => "uuid_123")
    empty_push = PushRequest.create(:success => true, :uuid => "uuid_123")
    first_site_push = PushRequest.create(:site_id => first_site.id, :success => true, :uuid => "uuid_124")
    first_peer_log = PeerLog.create(:push_request_id => first_site_push.id,
    :sync_object_action_id => action.id, :sync_object_type_id => type.id)
    second_peer_log = PeerLog.create(:push_request_id => first_site_push.id,
    :sync_object_action_id => action.id, :sync_object_type_id => type.id)
    peer_logs = PeerLog.new_logs_for_site(second_site)

    # check returned peer logs
    peer_logs = PeerLog.new_logs_for_site(second_site)
    peer_logs.count.should == 2
    peer_logs[0].id.should == first_peer_log.id
    peer_logs[1].id.should == second_peer_log.id

    # check combined peer logs
    combined_peer_logs = PeerLog.combine_logs_in_one_json(peer_logs)
    combined_peer_logs.count.should == 2
  end
end
