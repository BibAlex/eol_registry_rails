include PullRequestsHelper

class PullRequestsController < ApplicationController

  before_filter :set_response_format_to_json
  before_filter :authenticate_site, only: [ :pull, :report ]
  before_filter :validate_current_uuid, :validate_pull_request, only: [ :pull ]
  before_filter :validate_report_request, only: [ :report ]

  def pull
    latest_successful_push = PushRequest.latest_successful_push
    pull_event = process_pull_event(@site, latest_successful_push.uuid)
    # Now prepare the pull response in json
    resp_arr = {file_url: "#{REGISTRY_URL}#{pull_event.file_url}",
                file_md5_hash: "#{REGISTRY_URL}#{pull_event.file_md5_hash}",
                UUID: latest_successful_push.uuid}
    render json: resp_arr.to_json
  end

  def report
    uuid = params[:uuid]
    reason = params[:reason]
    # get the Pull
    pull_event = PullEvent.find_by_site_id_and_state_uuid_and_success(@site.id, uuid, nil)
    params[:success].to_bool ? pull_event.succeed(@site, uuid) : pull_event.fail(reason)
    render json: {success: pull_event.success, uuid: @site.current_uuid}.to_json
  end
end