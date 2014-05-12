class PushRequestsController < ApplicationController

  before_filter :set_response_format_to_json
  before_filter :authenticate_site, :validate_current_uuid, :validate_push_request, :only => [:create]

  def create
    process_push_request(@site.id, params[:file_url], params[:file_md5_hash])
    resp_arr = {:success => '' ,
                :message => 'processing',
                :uuid => uuid,
                :received_at => received_at}
    render :json => resp_arr.to_json
  end

  def show
    return render_error(400, 'Missing uuid') if params[:uuid].blank?

    push_request = PushRequest.find_by_uuid(params[:uuid])
    return render_error(401, 'Invalid uuid') unless push_request

    render :json => view_context.send_status_to_node(push_request)
  end
end
