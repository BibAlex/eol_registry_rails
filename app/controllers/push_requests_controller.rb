class PushRequestsController < ApplicationController
  def make_push
  	auth_code = params[:auth_code]
    current_uuid = params[:current_uuid]
    file_url = params[:file_url]
    file_md5_hash = params[:file_md5_hash]

    unless auth_code && current_uuid && file_url && file_md5_hash
      @message = view_context.error_message_to_json('Missing Parameters')
      render :json => @message
      return
    end

    # authenticate site
    site = Site.authenticate(auth_code)

    unless site
      @message = view_context.error_message_to_json('Invalid auth_code')
      render :json => @message
      return
    end

    # make sure that the site and the registry have the same UUID for this site 
    # TODO: if this check fails, then this node is out of sync. we need to figure out a procedure to fix this!
    unless (site.current_uuid == current_uuid)
      @message = view_context.error_message_to_json('Invalid current_uuid')
      render :json => @message
      return
    end

    # check if the registry is processing another request.
    # in the future we may remove this check if needed.
    if PushRequest.registry_is_busy?
      @message = view_context.error_message_to_json('Registry is busy')
      render :json => @message
      return
    end

    push_request = PushRequest.new
    push_request.site_id = site.id
    push_request.file_url = file_url
    push_request.file_md5_hash = file_md5_hash
    push_request.received_at = DateTime.now
    push_request.save 

    @message = view_context.send_processing_to_node(push_request.uuid, push_request.received_at)
    render :json => @message

  end

  def query
  	uuid = params[:uuid]

  	unless uuid  		
  		@message = view_context.error_message_to_json('Missing uuid')
  		render :json => @message
  		return
  	end

  	push_request = PushRequest.find_by_uuid(uuid)

  	unless push_request
  		# invalid uuid
  		@message = view_context.error_message_to_json('Invalid uuid')
  		render :json => @message
  		return
  	end

  	# render object
  	render :json => view_context.send_status_to_node(push_request)
  end
end
