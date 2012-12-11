require 'spec_helper'

describe PushRequest do 

	it 'should send success after successfull push' do
		push_request = PushRequest.new
		push_request.success = 1
		push_request.save

		uuid = push_request.uuid

		visit "/push_requests/query?uuid=#{uuid}"
		body.should include('"success":1')
	end
end