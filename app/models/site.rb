class Site < ActiveRecord::Base
  attr_accessible :auth_code, :current_uuid, :name, :response_url, :url

  has_many :PullEvent

  before_create :generate_auth_code
    

  def self.authenticate(auth_code)
    return Site.find_by_auth_code(auth_code)
  end



  private

    def generate_auth_code
      self.auth_code=generate_code unless self.auth_code?
    end

    def generate_code()
      # recursive function: generate auth_code and make sure it's unique
      allowed_string = ('0'..'9')
      code = allowed_string.to_a.shuffle.first(16).join
      if (Site.where(:auth_code => code).count > 0)
        # not unique, recurse
        generate_code
      else
        # unique, return it
        code
      end
    end
end
