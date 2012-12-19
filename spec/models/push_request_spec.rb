require 'spec_helper'

describe PushRequest do
  
  before (:all) do
    truncate_all_tables
  end

  it 'should generate uuid' do
    PushRequest.gen().uuid.should_not be_nil
  end

end