module ApplicationHelper
  def error_message_to_json(messsage)
  	arr = Array.new
  	arr['success'] = 0
  	arr['message'] = message

  	arr.to_json
  end

  def send_processing_to_node(uuid)
  	arr = Array.new
  	arr['success'] = 1
  	arr['message'] = 'processing'
  	arr['uuid'] = uuid

  	arr.to_json
  end
end
