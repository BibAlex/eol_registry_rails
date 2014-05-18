require 'spec_helper'

describe PushRequest do 

  it 'should send success after successfull push' do
    push_request = PushRequest.create(:success => true)
    uuid = push_request.uuid
    visit "/push_requests/show?uuid=#{uuid}"
    expect(body.include?('"success":1'))
  end

  it 'should accept push and send uuid' do
    # create a site
    site = Site.gen(:auth_code => "test_123")

    # create an empty push
    push_request = PushRequest.create(:success => true)
    uuid = push_request.uuid

    # assign the new uuid to the site
    site.update_column(:current_uuid, uuid)
    # send a push request and get the results
    visit "/push_requests/create?auth_code=#{site.auth_code}&current_uuid=#{uuid}&file_url=http://www.example.com/test.json&file_md5_hash=http://www.example.com/test.json"    
    expect(body.include?('"message":"processing"'))
  end
end