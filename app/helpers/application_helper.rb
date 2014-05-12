module ApplicationHelper
  def error_message_to_json(message)
    arr = {}
    arr[:success] = 0
    arr[:message] = message

    arr.to_json
  end
end
