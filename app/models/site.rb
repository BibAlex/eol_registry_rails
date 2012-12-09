class Site < ActiveRecord::Base
  attr_accessible :auth_code, :current_uuid, :name, :response_url, :url

  has_many :PullEvent
end
