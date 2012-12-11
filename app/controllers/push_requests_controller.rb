class PushRequestsController < ApplicationController
  def make_push
  	

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
