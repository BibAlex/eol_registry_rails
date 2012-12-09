class LogActionParameter < ActiveRecord::Base
  attr_accessible :param_object_id, :param_object_site_id, :param_object_type_id, :parameter, :peer_log_id, :value

  belongs_to :SyncObjectType, :foreign_key => :param_object_type_id
  belongs_to :Site, :foreign_key => :param_object_site_id
  belongs_to :PeerLog
end
