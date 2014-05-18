class InsertSites < ActiveRecord::Migration
  def up

    # Create Empty Push
    pr = PushRequest.create(success: 1,
                            received_at: DateTime.now,
                            success_at: DateTime.now)

    # Now create MBL site
    Site.create(name: 'MBL',
                url: 'http://localhost:3001',
                response_url: 'http://localhost:3001/sync_event_update',
                current_uuid: pr.uuid)
                
    # Now create MBL site
    Site.create(name: 'BA',
                url: 'http://localhost:3002',
                response_url: 'http://localhost:3002/sync_event_update',
                current_uuid: pr.uuid)
  end

  def down
    # Nothing to do
  end
end
