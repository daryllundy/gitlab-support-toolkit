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
    # This would integrate with GitLab API
    # For now, return a mock result
    {
      endpoint: test_params[:endpoint],
      method: test_params[:method],
      status: 'success',
      response_code: 200,
      response_time: rand(100..500),
      timestamp: Time.current,
      response_body: {
        message: 'Test successful',
        data: { test: true }
      }
    }
  end
  
  def store_test_result(result)
    session[:api_test_results] ||= []
    session[:api_test_results] << result
    # Keep only last 20 results
    session[:api_test_results] = session[:api_test_results].last(20)
  end
end