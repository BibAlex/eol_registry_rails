require 'spec_helper'

describe PullEvent do
  before(:all) do
    truncate_all_tables
  end

  describe "test pull event associations" do
    it "should belongs to site" do
      t = PullEvent.reflect_on_association(:site)
      t.macro.should == :belongs_to
    end
  end

  it "should set success attribute to true when pull success" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id)
    
    # check updated pull event
    pull_event.succeed(site, "uuid_125")
    pull_event.success.should == true
    pull_event.success_at.should_not be_nil
    pull_event.failed_at.should be_nil
    
    site.current_uuid.should == "uuid_125"
  end
  
  it "should set success attribute to false when pull fail" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id)
    
    # check updated pull event
    pull_event.fail("another pull is in progress")
    pull_event.success.should == false
    pull_event.failed_reason = "another pull is in progress"    
    pull_event.failed_at.should_not be_nil
    pull_event.success_at.should be_nil
    
  end
end
