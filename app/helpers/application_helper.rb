module ApplicationHelper
  def error_message_to_json(message)
    arr = {}
    arr[:success] = 0
    arr[:message] = message

    arr.to_json
  end

  

  def send_status_to_node(push_request)
    arr = {}
    arr[:success] = push_request.success
    arr[:success_at] = push_request.success_at if push_request.success == 1
    arr[:failed_at] = push_request.failed_at if push_request.success == 0
    arr[:failed_reason] = push_request.failed_reason if push_request.success == 0

    arr.to_json
  end


end
