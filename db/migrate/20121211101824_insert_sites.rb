class InsertSites < ActiveRecord::Migration
  def up

  	# Create Empty Push
  	pr = PushRequest.new
  	pr.success = 1
  	pr.received_at = DateTime.now
  	pr.success_at = DateTime.now
  	pr.save

  	# Now create MBL site
  	s = Site.new
  	s.name = 'MBL'
  	s.url = 'http://localhost:3001'
  	s.response_url = 'http://localhost:3001/sync_event_update'
  	s.current_uuid = pr.uuid
  	s.save

  	# Now create MBL site
  	s = Site.new
  	s.name = 'BA'
  	s.url = 'http://localhost:3002'
  	s.response_url = 'http://localhost:3002/sync_event_update'
  	s.current_uuid = pr.uuid
  	s.save

  end

  def down
  	# Nothing to do
  end
end
