require 'spec_helper'

describe PullEvent do
  
  before(:all) do
    truncate_all_tables      
  end
   
  describe "test pull event associations" do
    it "should belongs to site" do
      t = PullEvent.reflect_on_association(:site)
      expect(t.macro).to eq(:belongs_to)
    end
  end

  it "should set success attribute to true when pull success" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id)
    
    # check updated pull event
    pull_event.succeed(site, "uuid_125")
    expect(pull_event.success).to be_true
    expect(pull_event.success_at).not_to be_nil
    expect(pull_event.failed_at).to be_nil 
    expect(site.current_uuid).to eq("uuid_125")
  end
  
  it "should set success attribute to false when pull fail" do
    site = Site.create(auth_code: "auth_1", current_uuid: "uuid_124")
    pull_event = PullEvent.create(site_id: site.id)
    
    # check updated pull event
    pull_event.fail("another pull is in progress")
    expect(pull_event.success).to be_false
    expect(pull_event.failed_reason).to eq("another pull is in progress")
    expect(pull_event.failed_at).not_to be_nil 
    expect(pull_event.success_at).to be_nil
  end
end
