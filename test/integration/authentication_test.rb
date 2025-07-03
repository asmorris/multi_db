require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "root path redirects to login when not authenticated" do
    get "/"

    # Index now requires authentication
    assert_response :redirect
    assert_match %r{/login}, response.location
  end

  test "authentication routes are accessible" do
    get "/auth/login"
    assert_response :success

    get "/auth/create-account"
    assert_response :success
  end

  test "creating posts requires authentication" do
    post "/posts", params: { post: { name: "Test", description: "Test post" } }

    # Should redirect to authentication since create action requires auth
    assert_response :redirect
    assert_match %r{/login}, response.location
  end
end
