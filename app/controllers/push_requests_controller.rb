include PushRequestsHelper
class PushRequestsController < ApplicationController

  before_filter :set_response_format_to_json
  before_filter :authenticate_site, :validate_current_uuid, :validate_push_request, only: [:create]
  before_filter :validate_push_uuid, only: [:show]
  def create
    push_request = process_push_request(@site.id, params[:file_url], params[:file_md5_hash])
    resp_arr = {success: '' ,
                message: 'processing',
                uuid: push_request.uuid,
                received_at: push_request.received_at}
    render json: resp_arr.to_json
  end

  def show
    push_request = PushRequest.find_by_uuid(params[:uuid])
    resp_arr = {success: push_request.success,
                success_at: (push_request.success_at if push_request.success),
                failed_at: (push_request.failed_at if !push_request.success),
                failed_reason: (push_request.failed_reason if !push_request.success)}
    render json: resp_arr.to_json
  end
end
