class PeerLog < ActiveRecord::Base
  attr_accessible :action_taken_at_time, :push_request_id, :sync_object_action_id, :sync_object_id,
            :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id

  belongs_to :SyncObjectType, :foreign_key => :sync_object_type_id
  belongs_to :SyncObjectAction, :foreign_key => :sync_object_action_id
  belongs_to :Site, :foreign_key => :sync_object_site_id
  belongs_to :Site, :foreign_key => :user_site_id
end
