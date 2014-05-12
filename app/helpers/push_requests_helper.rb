module PushRequestsHelper
  def process_push_request(site_id, file_url, file_md5_hash)
    push_request = create_push_request(site_id, file_url, file_md5_hash)
  end

  private
    def create_push_request(site_id, file_url, file_md5_hash)
      push_request = PushRequest.new
      push_request.site_id = site_id
      push_request.file_url = file_url
      push_request.file_md5_hash = file_md5_hash
      push_request.received_at = DateTime.now
      push_request.save
      push_request
    end
end
