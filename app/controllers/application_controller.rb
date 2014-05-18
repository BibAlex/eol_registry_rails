class ApplicationController < ActionController::Base

  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local
    #rescue_from JSONException, with: lambda { |code, exception| render_error(code, exception) }
    #rescue_from Exception, with: lambda { |exception| render_error(500, exception) }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error(404, exception) }
  end
  
  def render_error(http_status, message)
    # 208 -> Nothing to pull
    # 400 -> Missing parameters
    # 401 -> Invalid UUID
    # 405 -> Registry busy
    # 406 -> Invalid Request
    # 409 -> Pull first
    respond_to do |format|
      #format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: http_status, locals: { exception: exception } }
      format.json {
        json_hash = {
          success: false,
          message: message }
        render json: json_hash.to_json, status: http_status
      }
      #format.all { render template: "errors/error_#{status}", layout: 'layouts/application', status: http_status, locals: { exception: exception } }
    end
  end

  def validate_push_request
    return render_error(400, 'Missing parameters') if params[:file_url].blank? || params[:file_md5_hash].blank?
    # check if the registry is processing another request.
    # in the future we may remove this check if needed.
    return render_error(405, 'Registry is busy') unless PushRequest.pending.empty?
    return render_error(409, 'Pull first') unless @site.up_to_date?
  end
  
  def validate_pull_request
    return render_error(405, 'Another pull is in progress') if @site.unprocessed_pulls.count > 0
    latest_successful_push = PushRequest.latest_successful_push
    return render_error(208, 'Nothing to pull') if latest_successful_push.nil? || @site.current_uuid == latest_successful_push.uuid 
  end
  
  def validate_report_request
    uuid = params[:uuid]
    success = params[:success]
    # get the Pull
    pull_event = PullEvent.find_by_site_id_and_state_uuid_and_success(@site.id, uuid, nil)
    return render_error(400, 'Missing parameters') if uuid.blank? || success.blank?
    return render_error(406, 'Invalid Pull') unless pull_event
    # the pull had already succeeded or failed
    return render_error(406, 'Pull has already been completed') if pull_event.success
  end
  
  def validate_push_uuid
    return render_error(400, 'Missing uuid') if params[:uuid].blank?
    push_request = PushRequest.find_by_uuid(params[:uuid])
    return render_error(401, 'Invalid uuid') unless push_request
    push_request
  end
  
  def set_response_format_to_json
    request.format = "json"
  end

  def authenticate_site
    return render_error(400, 'Missing auth_code') if params[:auth_code].blank?
    unless @site = Site.authenticate(params[:auth_code])
      return render_error(401, 'Invalid auth_code')
    end
  end

  def validate_current_uuid
    return render_error(400, 'Missing current_uuid') if params[:current_uuid].blank?
    # make sure that the site and the registry have the same UUID for this site
    # TODO: if this check fails, then this node is out of sync. we need to figure out a procedure to fix this!
    return render_error(401, 'Invalid current_uuid') unless @site.current_uuid == params[:current_uuid]
  end
  
end
