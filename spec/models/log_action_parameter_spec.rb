require 'spec_helper'

describe LogActionParameter do
  
    describe "test log action parameter associations" do
    it "should belongs to param object type" do
      t = LogActionParameter.reflect_on_association(:param_object_type)
      expect(t.macro).to eq(:belongs_to)      
    end

    it "should belongs to param object site" do
      t = LogActionParameter.reflect_on_association(:param_object_site)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belongs to sync peer log" do
      t = LogActionParameter.reflect_on_association(:peer_log)
      expect(t.macro).to eq(:belongs_to)
    end
  end
  
end
