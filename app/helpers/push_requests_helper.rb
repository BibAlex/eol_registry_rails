module PushRequestsHelper
  def process_push_request(site_id, file_url, file_md5_hash)
    push_request = create_push_request(site_id, file_url, file_md5_hash)
  end

  private
    def create_push_request(site_id, file_url, file_md5_hash)
      PushRequest.create(
      site_id: site_id,
      file_url: file_url,
      file_md5_hash: file_md5_hash,
      received_at: DateTime.now
      )
    end
end
