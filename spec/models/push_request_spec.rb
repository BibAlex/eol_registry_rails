require 'spec_helper'

describe PushRequest do

  before (:all) do
    truncate_all_tables
  end

  describe "test push request associations" do
    it "should belongs to site" do
      t = PushRequest.reflect_on_association(:site)
      t.macro.should == :belongs_to
    end
  end
  
  it "should return pending push requests" do    
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_123")
    finished_push_request = PushRequest.create(site_id: site.id, success: true, uuid: "uuid_123")
    pending_push_request = PushRequest.create(site_id: site.id, success: nil, uuid: "uuid_124")
   
    pending_push_requests = PushRequest.pending
    pending_push_requests.count.should == 1
    pending_push_requests[0].id.should == pending_push_request.id
  end
  
  it "should return latest successful push request" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_123")
    successful_push_request = PushRequest.create(site_id: site.id, success: true, uuid: "uuid_123")
    pending_push_request = PushRequest.create(site_id: site.id, success: nil, uuid: "uuid_124")
   
    latest_successful_push_requests = PushRequest.latest_successful_push
    latest_successful_push_requests.id.should == successful_push_request.id
    
  end

  it 'should generate uuid' do
    PushRequest.gen().uuid.should_not be_nil
  end
end