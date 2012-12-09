class CreatePeerLogs < ActiveRecord::Migration
  def change
    create_table :peer_logs do |t|
      t.integer :user_site_id
      t.integer :user_site_object_id
      t.datetime :action_taken_at_time
      t.integer :sync_object_action_id
      t.integer :sync_object_type_id
      t.integer :sync_object_id
      t.integer :sync_object_site_id
      t.integer :push_request_id

      t.timestamps
    end
  end
end
