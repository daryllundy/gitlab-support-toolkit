require 'net/http'
require 'json'

class GitlabApiService
  def initialize(gitlab_url, token)
    @gitlab_url = gitlab_url.chomp('/')
    @token = token
    @api_base = "#{@gitlab_url}/api/v4"
  end

  def test_connection
    response = make_request('GET', '/user')
    {
      success: response.code == '200',
      status_code: response.code.to_i,
      message: response.code == '200' ? 'Connection successful' : 'Connection failed',
      data: response.code == '200' ? JSON.parse(response.body) : nil
    }
  rescue => e
    {
      success: false,
      status_code: 0,
      message: "Connection error: #{e.message}",
      data: nil
    }
  end

  def get_projects(params = {})
    query_string = build_query_string(params)
    endpoint = "/projects#{query_string}"
    
    response = make_request('GET', endpoint)
    parse_response(response)
  rescue => e
    error_response("Failed to fetch projects: #{e.message}")
  end

  def get_project(project_id)
    response = make_request('GET', "/projects/#{project_id}")
    parse_response(response)
  rescue => e
    error_response("Failed to fetch project: #{e.message}")
  end

  def get_project_issues(project_id, params = {})
    query_string = build_query_string(params)
    endpoint = "/projects/#{project_id}/issues#{query_string}"
    
    response = make_request('GET', endpoint)
    parse_response(response)
  rescue => e
    error_response("Failed to fetch issues: #{e.message}")
  end

  def get_project_merge_requests(project_id, params = {})
    query_string = build_query_string(params)
    endpoint = "/projects/#{project_id}/merge_requests#{query_string}"
    
    response = make_request('GET', endpoint)
    parse_response(response)
  rescue => e
    error_response("Failed to fetch merge requests: #{e.message}")
  end

  def get_system_info
    response = make_request('GET', '/application/statistics')
    parse_response(response)
  rescue => e
    error_response("Failed to fetch system info: #{e.message}")
  end

  def create_issue(project_id, issue_data)
    response = make_request('POST', "/projects/#{project_id}/issues", issue_data)
    parse_response(response)
  rescue => e
    error_response("Failed to create issue: #{e.message}")
  end

  def update_issue(project_id, issue_iid, issue_data)
    response = make_request('PUT', "/projects/#{project_id}/issues/#{issue_iid}", issue_data)
    parse_response(response)
  rescue => e
    error_response("Failed to update issue: #{e.message}")
  end

  private

  def make_request(method, endpoint, data = nil)
    uri = URI("#{@api_base}#{endpoint}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.read_timeout = 30
    http.open_timeout = 10

    request = case method.upcase
    when 'GET'
      Net::HTTP::Get.new(uri)
    when 'POST'
      req = Net::HTTP::Post.new(uri)
      req.body = data.to_json if data
      req['Content-Type'] = 'application/json'
      req
    when 'PUT'
      req = Net::HTTP::Put.new(uri)
      req.body = data.to_json if data
      req['Content-Type'] = 'application/json'
      req
    when 'DELETE'
      Net::HTTP::Delete.new(uri)
    else
      raise "Unsupported HTTP method: #{method}"
    end

    request['Authorization'] = "Bearer #{@token}"
    request['User-Agent'] = 'GitLab Support Toolkit'

    http.request(request)
  end

  def parse_response(response)
    case response.code.to_i
    when 200..299
      {
        success: true,
        status_code: response.code.to_i,
        message: 'Request successful',
        data: JSON.parse(response.body),
        headers: response.to_hash
      }
    when 401
      {
        success: false,
        status_code: 401,
        message: 'Unauthorized - Invalid token or insufficient permissions',
        data: nil
      }
    when 403
      {
        success: false,
        status_code: 403,
        message: 'Forbidden - Access denied',
        data: nil
      }
    when 404
      {
        success: false,
        status_code: 404,
        message: 'Not found - Resource does not exist',
        data: nil
      }
    when 422
      error_data = JSON.parse(response.body) rescue {}
      {
        success: false,
        status_code: 422,
        message: "Validation error: #{error_data['message'] || 'Invalid data'}",
        data: error_data
      }
    when 429
      {
        success: false,
        status_code: 429,
        message: 'Rate limit exceeded - Please wait before making more requests',
        data: nil
      }
    when 500..599
      {
        success: false,
        status_code: response.code.to_i,
        message: 'Server error - GitLab instance may be experiencing issues',
        data: nil
      }
    else
      {
        success: false,
        status_code: response.code.to_i,
        message: "Unexpected response: #{response.code}",
        data: nil
      }
    end
  end

  def build_query_string(params)
    return '' if params.empty?
    
    query_params = params.map do |key, value|
      "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
    end.join('&')
    
    "?#{query_params}"
  end

  def error_response(message)
    {
      success: false,
      status_code: 0,
      message: message,
      data: nil
    }
  end
end