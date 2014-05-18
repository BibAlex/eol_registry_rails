require 'spec_helper'

describe Site do

  before (:all) do
    truncate_all_tables
  end

  describe "test site associations" do
    it "should has many to pull event" do
      t = Site.reflect_on_association(:pull_events)
      t.macro.should == :has_many
    end
    
     it "should has many to push requests" do
      t = Site.reflect_on_association(:push_requests)
      t.macro.should == :has_many
    end
    
     it "should belongs to current state push request" do
      t = Site.reflect_on_association(:current_state_push_request)
      t.macro.should == :belongs_to
    end
  end
  
  it "should return unprocessed pulls" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id, success: nil)
    finished_pull_event = PullEvent.create(site_id: site.id, success: true)

    unprocessed_pulls = site.unprocessed_pulls
    unprocessed_pulls.count.should == 1
    unprocessed_pulls[0].id.should == pull_event.id
  end
  
  describe "site state" do
    it "should return true if site is up to date" do
      site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
  
      is_up_to_date = site.up_to_date?
      is_up_to_date.should == true
    end
    
    it "should return false if site is not up to date" do
      site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
      site_2 = Site.create(auth_code: "auth_2", current_uuid: "uuid_123")  
      successful_push_request = PushRequest.create(site_id: site_2.id, success: true, uuid: "uuid_123")
     
      is_up_to_date = site.up_to_date?
      is_up_to_date.should == false
    end
  end
  
  it 'should authenticate a site' do
    site = Site.gen(auth_code: "test_123")
    Site.authenticate("test_123").should_not be_nil
  end

  it 'should generate auth_code' do
    Site.gen().auth_code.should_not be_nil
  end
end
