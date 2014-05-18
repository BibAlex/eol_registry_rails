require 'spec_helper'

describe PushRequest do

  describe "test push request associations" do
    it "should belongs to site" do
      t = PushRequest.reflect_on_association(:site)
      expect(t.macro).to eq(:belongs_to)
    end
  end
  
  it "should return pending push requests" do    
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_123")
    finished_push_request = PushRequest.create(site_id: site.id, success: true, uuid: "uuid_123")
    pending_push_request = PushRequest.create(site_id: site.id, success: nil, uuid: "uuid_124")
   
    pending_push_requests = PushRequest.pending
    expect(pending_push_requests.count).to eq(1)
    expect(pending_push_requests.first.id).to eq(pending_push_request.id)
  end
  
  it "should return latest successful push request" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_123")
    successful_push_request = PushRequest.create(site_id: site.id, success: true, uuid: "uuid_123")
    pending_push_request = PushRequest.create(site_id: site.id, success: nil, uuid: "uuid_124")
   
    latest_successful_push_requests = PushRequest.latest_successful_push
    expect(latest_successful_push_requests.id).to eq(successful_push_request.id)
  end

  it 'should generate uuid' do
    expect(PushRequest.gen().uuid).not_to be_nil
  end
end