class PullEvent < ActiveRecord::Base
  attr_accessible :pull_at, :site_id, :state_uuid, :success_at, :success 
  attr_accessible :file_url, :file_md5_hash, :failed_at, :failed_reason

  belongs_to :site
  
  def succeed(site, uuid)
    self.success = true
    self.success_at = DateTime.now
    self.save
    site.current_uuid = uuid
    site.save
  end
  
  def fail(reason)
    self.success = false
    self.failed_at = DateTime.now
    self.failed_reason = reason
    self.save
  end
end
