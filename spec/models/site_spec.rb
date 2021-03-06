require 'spec_helper'

describe Site do
  
  before(:all) do
    truncate_all_tables      
  end

  describe "test site associations" do
    it "should has many to pull event" do
      t = Site.reflect_on_association(:pull_events)
      expect(t.macro).to eq(:has_many)
    end
    
     it "should has many to push requests" do
      t = Site.reflect_on_association(:push_requests)
      expect(t.macro).to eq(:has_many)
    end
    
     it "should belongs to current state push request" do
      t = Site.reflect_on_association(:current_state_push_request)
      expect(t.macro).to eq(:belongs_to)
    end
  end
  
  it "should return unprocessed pulls" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id, success: nil)
    finished_pull_event = PullEvent.create(site_id: site.id, success: true)

    unprocessed_pulls = site.unprocessed_pulls
    expect(unprocessed_pulls.count).to eq(1)
    expect(unprocessed_pulls.first.id).to eq(pull_event.id)
  end
  
  describe "site state" do
    it "should return true if site is up to date" do
      site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
  
      is_up_to_date = site.up_to_date?
      expect(is_up_to_date).to be_true
    end
    
    it "should return false if site is not up to date" do
      site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
      site_2 = Site.create(auth_code: "auth_2", current_uuid: "uuid_123")  
      successful_push_request = PushRequest.create(site_id: site_2.id, success: true, uuid: "uuid_123")
     
      is_up_to_date = site.up_to_date?
      expect(is_up_to_date).to be_false
    end
  end
  
  it 'should authenticate a site' do
    site = Site.gen(:auth_code => "test_123")
    expect(Site.authenticate("test_123")).not_to be_nil 
  end

  it 'should generate auth_code' do
    expect(Site.gen().auth_code).not_to be_nil
  end
end
