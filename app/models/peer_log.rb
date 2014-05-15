class PeerLog < ActiveRecord::Base

  attr_accessible :action_taken_at, :push_request_id, :sync_object_action_id, :sync_object_id,
                  :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id

  belongs_to :push_request
  belongs_to :sync_object_type
  belongs_to :sync_object_action
  belongs_to :sync_object_site, :class_name => 'Site', :foreign_key => :sync_object_site_id
  belongs_to :user_site, :class_name => 'Site', :foreign_key => :user_site_id

  has_many :log_action_parameters

  def self.new_logs_for_site(site)
    PeerLog.joins(:push_request).where(["push_requests.id > ? AND push_requests.site_id != ? 
      AND push_requests.success IS TRUE", site.current_state_push_request.id, site.id])
  end
  
  def self.combine_logs_in_one_json(peer_logs)
    all_logs = []
    peer_logs.each do |peer_log|
      log_hash = create_hash(peer_log)
      parameter_array = create_parameters(peer_log.log_action_parameters)
      log_hash["log_action_parameters"] = parameter_array
      all_logs << log_hash
    end
    all_logs
  end
  
private
  def self.create_hash(peer_log)
    log_hash = {
      :user_site_id => peer_log.user_site_id,
      :user_site_object_id => peer_log.user_site_object_id,
      :action_taken_at => peer_log.action_taken_at,
      :sync_object_action => peer_log.sync_object_action.object_action,
      :sync_object_type => peer_log.sync_object_type.object_type,
      :sync_object_id => peer_log.sync_object_id,
      :sync_object_site_id => peer_log.sync_object_site_id
    }
  end
  def self.create_parameters(parameters)
    parameter_array = []
    parameters.each do |parameter|  
      parameter_hash = {}
      parameter_hash[:param_object_id] = parameter.param_object_id if parameter.param_object_id
      parameter_hash[:param_object_site_id] = parameter.param_object_site_id if parameter.param_object_site_id
      parameter_hash[:param_object_type] = parameter.param_object_type.object_type if parameter.param_object_type_id
      parameter_hash[:parameter] = parameter.parameter
      parameter_hash[:value] = parameter.value
      parameter_array << parameter_hash
    end  
    parameter_array
  end
end