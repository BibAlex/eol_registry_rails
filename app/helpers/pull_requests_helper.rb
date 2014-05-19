module PullRequestsHelper
  
  def process_pull_event(site, latest_successful_push_uuid)
    pull_event = create_pull_event(site.id, latest_successful_push_uuid)
    create_pull_files(pull_event.id, site)
    pull_event
  end
  
private

  def create_pull_event(site_id, latest_successful_push_uuid)
    # create the pull
    pull_event = PullEvent.create(
    site_id: site_id,
    pull_at: DateTime.now,
    state_uuid: latest_successful_push_uuid
    )
    pull_event.update_attributes(file_url: "/files/#{pull_event.id}.json", file_md5_hash: "/files/#{pull_event.id}.md5")
    pull_event
  end
  
  def create_pull_files(pull_event_id, site)
    peer_logs = PeerLog.new_logs_for_site(site) # Get Peer Logs for pending pushes
    combined_logs = PeerLog.combine_logs_in_one_json(peer_logs)
    file_url = File.join(Rails.root, 'public', 'files', "#{pull_event_id}.json")
    file_md5_hash = File.join(Rails.root, 'public', 'files', "#{pull_event_id}.md5")
    # prepare file for syncing
    File.open(file_url, 'w')  do |f|
      f.write(combined_logs.to_json)
    end

    # create the md5 hash
    File.open(file_md5_hash, 'w')  do |f|
      f.write(Digest::MD5.hexdigest(combined_logs.to_json))
    end
  end  
end
