class PullEvent < ActiveRecord::Base
  attr_accessible :pull_at, :site_id, :state_uuid, :success_at, :success 
  attr_accessible :file_url, :file_md5_hash, :failed_at, :failed_reason

  belongs_to :site
  
  def succeed(site, uuid)
    self.update_attributes(success: true, success_at: DateTime.now)
    site.update_attribute(:current_uuid, uuid)
  end
  
  def fail(reason)
    self.update_attributes(success: false, failed_at: DateTime.now, failed_reason: reason)
  end
end
