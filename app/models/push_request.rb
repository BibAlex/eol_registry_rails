class PushRequest < ActiveRecord::Base
  attr_accessible :failed_at, :failed_reason, :file_md5_hash, :file_url
  attr_accessible :received_at, :site_id, :success, :success_at, :uuid
  
  belongs_to :Site
end
