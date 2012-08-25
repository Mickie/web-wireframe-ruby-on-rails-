module XHRHelpers
  def add_xhr_headers
    request.env['HTTP_ACCEPT'] = 'application/json, text/javascript, */*'
    request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
  end
end