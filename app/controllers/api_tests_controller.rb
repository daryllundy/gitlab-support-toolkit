class ApiTestsController < ApplicationController
  def index
    @test_results = session[:api_test_results] || []
  end
  
  def create
    @test_params = test_params
    
    begin
      result = perform_api_test(@test_params)
      store_test_result(result)
      redirect_to api_tests_path, notice: 'API test completed successfully.'
    rescue => e
      redirect_to api_tests_path, alert: "API test failed: #{e.message}"
    end
  end
  
  def clear_results
    session[:api_test_results] = []
    redirect_to api_tests_path, notice: 'Test results cleared.'
  end
  
  private
  
  def test_params
    params.require(:api_test).permit(:gitlab_url, :endpoint, :method, :token, :parameters)
  end
  
  def perform_api_test(test_params)
    start_time = Time.current
    
    gitlab_service = GitlabApiService.new(test_params[:gitlab_url], test_params[:token])
    
    result = case test_params[:endpoint]
    when '/user', '/api/v4/user'
      gitlab_service.test_connection
    when /\/projects$/
      params = parse_json_params(test_params[:parameters])
      gitlab_service.get_projects(params)
    when /\/projects\/\d+$/
      project_id = test_params[:endpoint].split('/').last
      gitlab_service.get_project(project_id)
    when /\/application\/statistics$/
      gitlab_service.get_system_info
    else
      # Generic API call for custom endpoints
      perform_custom_api_call(gitlab_service, test_params)
    end
    
    response_time = ((Time.current - start_time) * 1000).round(2)
    
    {
      endpoint: test_params[:endpoint],
      method: test_params[:method],
      status: result[:success] ? 'success' : 'error',
      response_code: result[:status_code],
      response_time: response_time,
      timestamp: Time.current,
      response_body: result[:data] || { message: result[:message] },
      message: result[:message]
    }
  end
  
  def perform_custom_api_call(gitlab_service, test_params)
    # For custom endpoints, make a direct API call
    begin
      response = gitlab_service.send(:make_request, test_params[:method], test_params[:endpoint])
      gitlab_service.send(:parse_response, response)
    rescue => e
      {
        success: false,
        status_code: 0,
        message: "Custom API call failed: #{e.message}",
        data: nil
      }
    end
  end
  
  def parse_json_params(params_string)
    return {} if params_string.blank?
    JSON.parse(params_string)
  rescue JSON::ParserError
    {}
  end
  
  def store_test_result(result)
    session[:api_test_results] ||= []
    session[:api_test_results] << result
    # Keep only last 20 results
    session[:api_test_results] = session[:api_test_results].last(20)
  end
end